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
    log(DEBUG, 'access static resource run')
    local rules = policy['policies']['static_resource']
    local objects = policy['policies']['object']

    for id, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local rule_objects = rule['objects']
            for _, rule_object in ipairs(rule_objects) do
                if objects[rule_object] ~= nil and match(objects[rule_object]['conditions']) then
                    ngx.req.set_header('waf_static_resource_root', rule['target'])
                    ngx.req.set_header('waf_static_resource_expires', rule['expires'])
                    return exec('@waf_static_resource')
                end
            end
        end
    end
    return true
end

return _M
