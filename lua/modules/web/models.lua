local gconf = require 'modules.configs.gconf'
local file = require 'modules.utils.file'

local string_format = string.format
local ngx_time = ngx.time
local randomseed = math.randomseed
local random = math.random
local read_json = file.read_json
local write_json = file.write_json
local read_file = file.read_file
local write_file = file.write_file


local data_dir = gconf.PROJECT_DATAS_DIR

local policy_files = gconf.policy_files


local _M = {}
_M._VERSION = 1.0

local gen_id = function()
    local time = ngx_time()
    randomseed(time)
    return string_format('%d%06d', time, random(0, 10000))
end

local parse_policy = function(ptype, args)
    if ptype == 'object' then
        local policy = {}
        policy.id = args.id
        policy.name = args.name
        local conditions = {}
        for _, v in ipairs({'object', 'operate', 'target'}) do
            if type(args[v]) ~= 'table' then
                args[v] = {args[v]}
            end
        end
        for i, k in ipairs(args.object) do
            local condition = {
                    object = args.object[i],
                    operate = args.operate[i],
                    target = args.target[i],
            }
            conditions[#conditions + 1] = condition
        end
        policy.conditions = conditions
        return policy
    elseif ptype == 'loadbalance' then
        local policy = {}
        policy.id = args.id
        policy.name = args.name
        policy.type = args.type
        policy.object = args.object
        policy.enable = args.enable
        local targets = {}
        for _, v in ipairs({'scheme', 'ip', 'port', 'weight'}) do
            if type(args[v]) ~= 'table' then
                args[v] = {args[v]}
            end
        end
        for i, k in ipairs(args.scheme) do
            local target = {
                    scheme = args.scheme[i],
                    ip = args.ip[i],
                    port = args.port[i],
                    weight = args.weight[i],
            }
            targets[#targets + 1] = target
        end
        policy.targets = targets
        return policy
    elseif ptype == 'frequency' then
        if type(args['keys']) ~= 'table' then
            args['keys'] = {args['keys']}
        end
    end
    return args

end

_M.get_version = function(ptype)
    local file_name = policy_files[ptype]
    if file_name == nil then
        return {}
    end
    local path = string_format('%s/%s.version', data_dir, file_name)
    local version = read_file(path)
    return version
end

local get_policies = function(ptype)
    local file_name = policy_files[ptype]
    if file_name == nil then
        return {}
    end
    local path = string_format('%s/%s', data_dir, file_name)
    return read_json(path)
end

local save_policies = function(ptype, policies)
    local file_name = policy_files[ptype]
    if file_name == nil then
        return false
    end

    local path = string_format('%s/%s', data_dir, policy_files[ptype])
    local version = string_format('%s/%s.version', data_dir, policy_files[ptype])

    return write_json(policies, path) and write_file(ngx_time(), version)
end

_M.get_policies = get_policies

_M.get_policies_list = function(ptype)
    local policies = get_policies(ptype)
    local rt_policies = {}
    for _, v in pairs(policies) do
        rt_policies[#rt_policies + 1] = v
    end
    return rt_policies
end

_M.create_policy = function(ptype, args)
    args.id = gen_id()
    local policies = get_policies(ptype)
    policies[args.id] = parse_policy(ptype, args)
    return save_policies(ptype, policies)
end

_M.get_policy = function(ptype, args)
    if args.id ~= nil then
        local policies = get_policies(ptype)
        if policies[args.id] ~= nil then
            return policies[args.id]
        end
    end
    return {}
end

_M.modify_policy = function(ptype, args)
    if args.id ~= nil then
        local policies = get_policies(ptype)
        if policies[args.id] ~= nil then
            policies[args.id] = parse_policy(ptype, args)
            save_policies(ptype, policies)
            return true
        end
    end
    return false
end

_M.delete_policy = function(ptype, args)
    if args.id ~= nil then
        local policies = get_policies(ptype)
        if policies[args.id] ~= nil then
            local rt_policies = {}
            for k, v in pairs(policies) do
                if k ~= args.id then
                    rt_policies[k] = v
                end
            end
            return save_policies(ptype, rt_policies)
        end
    end
    return true
end
return _M
