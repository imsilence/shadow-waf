local log = ngx.log
local DEBUG = ngx.DEBUG
local ngx_var = ngx.var

log(DEBUG, 'access')

local filter = require 'modules.etl.action.access.filter'
filter.run()

local frequency = require 'modules.etl.action.access.frequency'
frequency.run()

local rate_limit = require 'modules.etl.action.access.rate_limit'
rate_limit.run()
