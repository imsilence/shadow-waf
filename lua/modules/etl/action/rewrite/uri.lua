local json = require 'cjson'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local gsub = ngx.re.gsub
local string_format = string.format
local redirect = ngx.redirect
local req_set_uri = ngx.req.set_uri

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'rewrite uri run')

    local rules = policy['policies']['uri']
    if(type(rules) ~= 'table') then
        return ture
    end

    local objects = policy['policies']['object']

    for _, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['condition']
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                local ouri = string_format('%s://%s:%s%s', ngx.var.scheme, ngx.var.host, ngx.var.server_port, ngx.var.request_uri)

                local uri = gsub(ngx.var.uri, rule['replace'], rule['to_uri'], 'ijo')
                if ngx.var.uri == uri then
                    return true
                end

                if ngx.var.is_args == '?' then
                    uri = string_format('%s?%s', uri, ngx.var.args)
                end

                local uri_all = string_format('%s://%s:%s%s', ngx.var.scheme, ngx.var.host, ngx.var.server_port, uri)

                log(DEBUG, string_format('rewrite "%s" to "%s"', ouri, uri_all))
                req_set_uri(uri)
                return false
            end
        end
    end
    return true
end

return _M
