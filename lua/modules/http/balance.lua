local json = require 'modules.utils.json'
local balancer = require 'ngx.balancer'

local set_current_peer = balancer.set_current_peer
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR
local log = ngx.log
local DEBUG = ngx.DEBUG

log(DEBUG, 'loadbalance')

local ok, err = set_current_peer('127.0.0.1', 8888)
if not ok then
    return exit(HTTP_INTERNAL_SERVER_ERROR)
end
