
local exit = ngx.exit
local string_sub = string.sub
local string_len = string.len
local string_gsub = string.gsub
local HTTP_OK = ngx.HTTP_OK
local HTTP_NOT_FOUND = ngx.HTTP_NOT_FOUND

local gconf = require 'modules.configs.gconf'
local router = require 'modules.web.router'

local uri = ngx.var.uri

local action_start = string_len(gconf.PREFIX_URI) + 1
local action_end = '/' == string_sub(uri, -1) and -2 or -1
local action = string_gsub(string_sub(uri, action_start, action_end), '/', '_')
action = action == '' and 'index' or action

local func = router[action]

if func ~= nil then
    func()
    exit(HTTP_OK)
end

exit(HTTP_NOT_FOUND)
