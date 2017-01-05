local json = require 'modules.utils.json'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'

local log = ngx.log
local DEBUG = ngx.DEBUG
local gsub = ngx.re.gsub
local string_format = string.format
local string_find = string.find
local redirect = ngx.redirect

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'rewrite redirect run')

    local rules = policy['policies']['redirect']
    local objects = policy['policies']['object']

    for _, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                local ouri = string_format('%s://%s:%s%s', ngx.var.scheme, ngx.var.host, ngx.var.server_port, ngx.var.request_uri)

                local uri = gsub(ngx.var.uri, rule['uri'], rule['target'], 'ijo')
                if ngx.var.uri == uri then
                    return true
                end

                if string_find(uri, 'http') ~= 1 then
                    uri = string_format('%s://%s:%s%s', ngx.var.scheme, ngx.var.host, ngx.var.server_port, uri)
                end

                if ngx.var.is_args == '?' then
                    uri = string_format('%s?%s', uri, ngx.var.args)
                end

                log(DEBUG, string_format('rewrite "%s" to "%s"', ouri, uri))
                redirect(uri, ngx.HTTP_MOVED_TEMPORARILY)
                return false
            end
        end
    end
    return true
end

return _M
