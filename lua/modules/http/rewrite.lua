local log = ngx.log
local DEBUG = ngx.DEBUG
local ngx_var = ngx.var

log(DEBUG, 'access')

local policy = require 'modules.configs.policy'
policy.reload()
do return end
local redirect = require 'modules.etl.action.rewrite.redirect'
redirect.run()

local browser = require 'modules.etl.action.rewrite.browser'
browser.run()
