local log = ngx.log
local DEBUG = ngx.DEBUG
local arg = ngx.arg

log(DEBUG, 'body filter')
log(DEBUG, 'response:', arg[1])
