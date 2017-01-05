
local string_format = string.format

local _M = {}
_M._VERSION = 1.0

_M.PREFIX_URI = '/waf/'

_M.PROJECT_HOME = ngx.config.prefix()

_M.PROJECT_DATAS_DIR = string_format('%s/datas/', _M.PROJECT_HOME)

_M.policy_files = {
    object = 'object.json',
    redirect = 'redirect.json',
    rule = 'rule.json',
    browser = 'browser.json',
    rate_limit = 'rate_limit.json',
    frequency = 'frequency.json',
    loadbalance = 'loadbalance.json',
}

return _M
