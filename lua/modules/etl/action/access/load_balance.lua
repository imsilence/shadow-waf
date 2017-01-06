local json = require 'modules.utils.json'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local exec = ngx.exec
local ngx_time = ngx.time
local randomseed = math.randomseed
local random = math.random

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

local choose_target = function(type, targets)
    local weight_total = 0
    for _, v in ipairs(targets) do
        weight_total = weight_total + tonumber(v['weight'])
    end
    local index = 0
    if type == 'random' then
        randomseed(ngx_time())
        index = random(0, 10000) % weight_total + 1
    elseif type == 'ip_hash' then
        index = ngx.crc32_short(ngx.var.remote_addr) % weight_total + 1
    elseif type == 'url_hash' then
        index = ngx.crc32_short(ngx.var.uri) % weight_total + 1
    end
    for _, v in ipairs(targets) do
        local weight = tonumber(v['weight'])
        if index <= weight then
            return v
        else
            index = index - weight
        end
    end
end

_M.run = function()
    log(DEBUG, 'access load balance run')
    local rules = policy['policies']['load_balance']
    local objects = policy['policies']['object']

    for id, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local rule_objects = rule['objects']
            for _, rule_object in ipairs(rule_objects) do
                if objects[rule_object] ~= nil and match(objects[rule_object]['conditions']) then
                    local target = choose_target(rule['type'], rule['targets'])
                    ngx.req.set_header('waf_load_balance_scheme', target['scheme'])
                    ngx.req.set_header('waf_load_balance_ip', target['ip'])
                    ngx.req.set_header('waf_load_balance_port', target['port'])
                    return exec('@waf_load_balance')
                end
            end
        end
    end
    return true
end

return _M
