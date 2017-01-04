local json = require 'cjson'

local json_decode = json.decode
local json_encode = json.encode

local _M = {}
_M._VERSION = 1.0

_M.decode = function(str)
    local json_value = nil
    pcall(function(str) json_value = json_decode(str)  end, str)
    return json_value
end

_M.encode = function(data)
    local json_str = nil
    pcall(function(data) json_str = json_encode(data) end, data)
    return json_str
end

return _M
