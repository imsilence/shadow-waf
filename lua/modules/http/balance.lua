local json = require 'modules.utils.json'
local balancer = require 'ngx.balancer'
local ngx_req = ngx.req

local set_current_peer = balancer.set_current_peer
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR
local log = ngx.log
local DEBUG = ngx.DEBUG

log(DEBUG, 'balance')

local headers = ngx_req.get_headers()
local ok, err = set_current_peer(headers['waf_load_balance_ip'], tonumber(headers['waf_load_balance_port']))
if not ok then
    return exit(HTTP_INTERNAL_SERVER_ERROR)
end
