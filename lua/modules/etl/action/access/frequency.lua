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

    log(DEBUG, 'access frequency run')
    local rules = policy['policies']['frequency']
    local objects = policy['policies']['object']

    local response = policy['response']

    for id, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                local interval = tonumber(rule['interval'])
                local limit = tonumber(rule['limit'])
                local ngx_var = ngx.var

                local keys = rule['keys']
                local cached_key = tostring(id)
                for _, key in ipairs(keys) do
                    if ngx_var[key] ~= nil then
                        cached_key = cached_key .. ngx_var[key]
                    end
                end
                local shard_frequency = ngx.shared.frequency
                local count = shard_frequency:get(cached_key)
                if count == nil then
                    count = 0
                    shard_frequency:set(cached_key, 0, interval)
                end
                shard_frequency:incr(cached_key, 1)
                count = tonumber(count) + 1

                if count > limit then
                    if '' ~= response['text'] then
                        say(response['text'])
                        exit(200)
                    else
                        exit(response['code'])
                    end
                    return false
                end
                return true
            end
        end
    end
    return true
end

return _M
