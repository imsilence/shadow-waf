local log = ngx.log
local DEBUG = ngx.DEBUG

log(DEBUG, 'init')

local init = require 'modules.etl.init'
init.init()
