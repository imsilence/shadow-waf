local json = require 'modules.utils.json'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local string_format = string.format
local log = ngx.log
local DEBUG = ngx.DEBUG
local say = ngx.say
local exit = ngx.exit

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'access filter run')
    local rules = policy['policies']['rate_limit']
    local objects = policy['policies']['object']

    local response = policy['response']

    for _, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local rule_objects = rule['objects']
            for _, rule_object in ipairs(rule_objects) do
                if objects[rule_object] ~= nil and match(objects[rule_object]['conditions']) then
                    ngx.var.limit_rate = string_format('%dK', tonumber(rule['target']))
                    return true
                end
            end
        end
    end
    return true
end

return _M
