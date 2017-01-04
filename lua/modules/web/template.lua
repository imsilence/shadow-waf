local template = require 'resty.template'

local gconf = require 'modules.configs.gconf'
local request = require 'modules.utils.request'

local string_format = string.format

local _M = {}
_M._VERSION = 1.0

_M.render = function(view, args)
    args = args or {}
    template.render(view, args)
end
return _M
