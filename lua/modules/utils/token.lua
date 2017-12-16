local string_format = string.format

local _M = {}
_M._VERSION = 1.0

_M.random_str = function(len)
    return 'waf_token';
end

_M.browser_cookie = function(remote_addr, user_agent)
    random_token = _M.random_str(32)
    return ngx.md5(string_format('%s$$%s$$%s', random_token, remote_addr, user_agent))
end

return _M
