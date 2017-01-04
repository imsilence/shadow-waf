local json = require 'cjson'
local policy = require 'modules.configs.policy'
local matcher = require 'modules.etl.match.matcher'
local token = require 'modules.utils.token'

local log = ngx.log
local DEBUG = ngx.DEBUG
local redirect = ngx.redirect
local string_find = string.find
local string_format = string.format

local match = matcher.match

local _M = {}
_M._VERSION = 1.0

_M.run = function()
    log(DEBUG, 'rewrite browser run')
    local rules = policy['policies']['browser']
    local objects = policy['policies']['object']

    local waf_token = string_format('waf_token=%s', token.browser_cookie(ngx.var.remote_addr, ngx.var.http_user_agent))

    for _, rule in ipairs(rules) do
        if rule['enable'] == 'true' then
            local condition = rule['object']
            if objects[condition] ~= nil and match(objects[condition]['conditions']) then
                if ngx.var.http_cookie ~= nil and string_find(ngx.var.http_cookie, waf_token) ~= nil then
                    return true
                end
                local uri = string_format('%s://%s:%s%s', ngx.var.scheme, ngx.var.host, ngx.var.server_port, ngx.var.request_uri)
                ngx.header['Set-Cookie'] = {string_format('%s; path=/', waf_token)}
                redirect(uri, ngx.HTTP_MOVED_TEMPORARILY)
                return false
            end
        end
    end
    return true
end

return _M
