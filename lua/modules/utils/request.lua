local json = require 'modules.utils.json'

local req = ngx.req
local json_decode = json.decode

local _M = {}
_M._VERSION = 1.0

local _merge_args = function(args, target)
    if args == nil or type(args) ~= 'table' then
        return
    end
    for k, v in pairs(args) do
        target[k] = v
    end
end

_M.get_args = function()
    local args = {}
    local uri_args = req.get_uri_args()
    _merge_args(uri_args, args)

    req.read_body()
    local post_args = req.get_post_args()
    _merge_args(post_args, args)

    local body = req.get_body_data()
    _merge_args(json_decode(body), args)
    return args
end

return _M
