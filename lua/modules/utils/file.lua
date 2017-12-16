local json = require 'modules.utils.json'

local json_encode = json.encode
local json_decode = json.decode

local _M = {}
_M._VERSION = 1.0

_M.read_file = function(path)
    local cxt = ''
    local file, err = io.open(path, 'rb')
    if nil == err then
        cxt = file:read('*a')
        file:close()
    end
    return cxt
end

_M.read_json = function(path)
    local json_value = json_decode(_M.read_file(path))
    return json_value == nil and {} or json_value
end

_M.write_file = function(str, path)
    local file, err = io.open(path, 'wb')
    if nil == err then
        file:write(str)
        file:flush()
        file:close()
        return true
    end
    return false
end

_M.write_json = function(json_value, path)
    local json_str =json_encode(json_value)
    json_str = json_str == nil and '{}' or json_str
    return _M.write_file(json_str, path)
end

return _M
