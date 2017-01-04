local log = ngx.log
local DEBUG = ngx.DEBUG
local string_format = string.format

local _M = {}
_M._VERSION = 1.0

local _funcs_match = {}
local _funcs_judge = {}

_M.match = function(condition)
    for _, k in ipairs(condition) do
        local func_name = string_format('_match_%s', k['object'])
        local func = _funcs_match[func_name]

        if func ~= nil and func(k['operate'], k['target']) ~= true then
            return false
        end
    end
    return true
end

local _judge = function(value, operate, target, type)
    if target == '*' then
        return true
    end
    if type == 'string' then
        value = tostring(value)
    elseif type == 'number' then
        value = tonumber(value)
    end
    local func_name = string_format('_judge_%s', operate)
    local func = _funcs_judge[func_name]
    return func == nil or func(value, target)
end

_funcs_match._match_time = function(operate, target)
    return _judge(ngx.time(), operate, target)
end

_funcs_match._match_remote_addr = function(operate, target)
    return _judge(ngx.var.remote_addr, operate, target)
end

_funcs_match._match_user_agent = function(operate, target)
    return _judge(ngx.var.http_user_agent, operate, target)
end

_funcs_match._match_referer = function(operate, target)
    return _judge(ngx.var.http_referer, operate, target)
end

_funcs_match._match_scheme = function(operate, target)
    return _judge(ngx.var.scheme, operate, target)
end

_funcs_match._match_host = function(operate, target)
    return _judge(ngx.var.host, operate, target)
end

_funcs_match._match_port = function(operate, target)
    return _judge(ngx.var.server_port, operate, target)
end

_funcs_match._match_uri = function(operate, target)
    return _judge(ngx.var.uri, operate, target)
end

_funcs_match._match_method = function(operate, target)
    return _judge(ngx.var.request_method, operate, target)
end

_funcs_match._match_args = function(operate, target)
    local args = {}
    for k, v in pairs(args) do
        if _judge(v, operate, target) ~= true then
            return false
        end
    end
    return _judge(target, operate, args)
end

_funcs_judge._judge_eq = function(value, target)
    return value == target
end

_funcs_judge._judge_gt = function(value, target)
    return value > target
end

_funcs_judge._judge_lt = function(value, target)
    return value < target
end

_funcs_judge._judge_gte = function(value, target)
    return value >= target
end

_funcs_judge._judge_lte = function(value, target)
    return value <= target
end

_funcs_judge._judge_regular = function(value, target)
    return ngx.re.find(value, target, 'ijo') ~= nil
end

_funcs_judge._judge_exists = function(value, target)
    return value ~= nil and type(value) == 'table' and value.target ~= nil
end

return _M
