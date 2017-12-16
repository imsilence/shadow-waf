local log = ngx.log
local DEBUG = ngx.DEBUG

log(DEBUG, 'init worker: ', ngx.worker.id())
