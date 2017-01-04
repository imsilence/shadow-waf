local json = require 'cjson'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local string_format = string.format
local redirect = ngx.redirect

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'rewrite scheme run')
    local config = policy['policies']['rewrite']['scheme']

    if config['enable'] ~= true then
        return true
    end

    local scheme = ngx.var.scheme
    local conditions = policy['conditions']
    local rules = config['rules']

    for _, rule in ipairs(rules) do
        if rule['enable'] == true then
            local condition = rule['condition']
            if match(conditions[condition]) == true then
                if scheme ~= rule['scheme'] then
                    local ouri = string_format('%s://%s:%s%s', scheme, ngx.var.host, ngx.var.server_port, ngx.var.request_uri)
                    local uri = string_format('%s://%s:%s%s', rule['scheme'], ngx.var.host, rule['port'], ngx.var.request_uri)

                    log(DEBUG, string_format('rewrite "%s" to "%s"', ouri, uri))
                    redirect(uri, ngx.HTTP_MOVED_TEMPORARILY)
                end
                return false
            end
        end
    end
    return true
end

return _M
