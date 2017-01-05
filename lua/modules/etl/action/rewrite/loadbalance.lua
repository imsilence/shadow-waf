local json = require 'modules.utils.json'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local exec = ngx.exec

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()

    log(DEBUG, 'access loadbalance run')
    local rules = policy['policies']['loadbalance']
    local objects = policy['policies']['object']

    for id, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                ngx.var.is_loadbalance = '1'
                ngx.var.loadbalance_scheme = 'http'
                ngx.var.loadbalance_ip = '127.0.0.1'
                ngx.var.loadbalance_port = 8888
                ngx.req.set_uri('/loadbalance', true)
                ngx.exit(200)
            end
        end
    end
    return true
end

return _M
