
local json = require 'modules.utils.json'
local template = require 'modules.web.template'
local models = require 'modules.web.models'
local request = require 'modules.utils.request'


local json_encode = json.encode
local get_args = request.get_args

local _M = {}
_M._VERSION = 1.0

_M.index = function()
    template.render('index.html')
end

_M.policy_object = function()
    template.render('policy_object.html')
end

_M.policy_list = function()
    local args = get_args()
    local policy_objects = models.get_policies_list(args.ptype)
    ngx.print(json_encode({data = policy_objects}))
end

_M.policy_create = function()
    local args = get_args()
    local ok, err = models.create_policy(args.ptype, args)
    ngx.print(json_encode({code = 200, result=''}))
end

_M.policy_delete = function()
    local args = get_args()
    local ok = models.delete_policy(args.ptype, args)
    ngx.print(json_encode({code = 200, result=''}))
end

_M.policy_view = function()
    local args = get_args()
    local object = models.get_policy(args.ptype, args)
    ngx.print(json_encode({code = 200, result=object}))
end

_M.policy_modify = function()
    local args = get_args()
    local ok, err = models.modify_policy(args.ptype, args)
    ngx.print(json_encode({code = 200, result=''}))
end

_M.policy_redirect = function()
    template.render('policy_redirect.html')
end

_M.policy_rule = function()
    template.render('policy_rule.html')
end

_M.policy_browser = function()
    template.render('policy_browser.html')
end

_M.policy_rate_limit = function()
    template.render('policy_rate_limit.html')
end

_M.policy_frequency = function()
    template.render('policy_frequency.html')
end

_M.policy_balance = function()
    template.render('policy_balance.html')
end

_M.policy_static = function()
    template.render('policy_static.html')
end

return _M
