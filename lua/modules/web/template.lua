local template = require 'resty.template'

local _M = {}
_M._VERSION = 1.0

_M.render = function(view, args)
    args = args or {}
    template.render(view, args)
end
return _M
