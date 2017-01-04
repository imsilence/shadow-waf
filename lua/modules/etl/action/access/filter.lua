local json = require 'cjson'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local say = ngx.say
local exit = ngx.exit

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'access filter run')
    local rules = policy['policies']['rule']
    local objects = policy['policies']['object']

    local response = policy['response']

    for _, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                if rule['action'] == 'drop' then
                    if '' ~= response['text'] then
                        say(response['text'])
                        exit(200)
                    else
                        exit(response['code'])
                    end
                    return false
                elseif rule['action'] == 'accept' then
                    return true
                end
            end
        end
    end
    return true
end

return _M
