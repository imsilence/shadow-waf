local string_format = string.format
local json = require 'modules.utils.json'
local gconf = require 'modules.configs.gconf'
local models = require 'modules.web.models'

local json_encode = json.encode
local json_decode = json.decode
local policy_files = gconf.policy_files
local get_version = models.get_version
local get_policies = models.get_policies
local get_policies_list = models.get_policies_list


local _M = {}
_M._VERSION = 1.0

_M.policies = {
    rewrite = {
        scheme = {
            enable = false,
            rules = {
                {
                    enable = true,
                    scheme = 'https',
                    condition = 'all',
                    port = '443',
                }
            }
        },
        browser = {
            enable = true,
            rules = {
                {
                    enable = true,
                    condition = 'localhost',
                }
            }
        },
        redirect = {
            enable = false,
            rules = {
                {
                    enable = true,
                    condition = 'all',
                    replace = '^/baidu/',
                    to_uri = 'http://www.baidu.com',
                }
            }
        },
        uri = {
            enable = false,
            rules = {
                {
                    enable = true,
                    condition = 'all',
                    replace = '^/baidu/',
                    to_uri = '/index.html',
                }
            }
        }
    },
    access = {
        filter = {
            enable = false,
            rules = {
                {
                    enable = true,
                    condition = 'localhost',
                    action = 'accept',
                    response = 'html',
                    code = ngx.HTTP_BAD_REQUEST,
                },
                {
                    enable = true,
                    condition = 'all',
                    action = 'drop',
                    response = 'html',
                    code = ngx.HTTP_BAD_REQUEST,
                }
            }
        },
        frequency = {
            enable = false,
            rules = {
                {
                    enable = true,
                    keys = {'remote_addr', 'uri'},
                    condition = 'all',
                    limit = 10,
                    interval = 60,
                    response = 'html',
                    code = ngx.HTTP_BAD_REQUEST,
                }

            }
        }
    },
}

_M.conditions = {
    all = {},
    localhost = {
        {
            object = 'remote_addr',
            operate = 'eq',
            target = '127.0.0.1'
        },
        {
            object = 'uri',
            operate = 'regular',
            target = '/test.json$',
        }
    },
    api = {
        {
            object = 'uri',
            operate = 'regular',
            target = '/(.*).json$'
        }
    }

}

_M.response = {
    text = 'not allow access',
    code = 400
}

_M.reload = function()
    local shard_policy = ngx.shared.policy
    local policies = {}
    for k, _ in pairs(policy_files) do
        local key_version = string_format('version_%s', k)
        local cached_version = shard_policy:get(key_version)
        local version = get_version(k)

        local policy = nil
        if cached_version == nil or cached_version ~= version then
            if k == 'object' then
                policy = get_policies(k)
            else
                policy = get_policies_list(k)
            end
            shard_policy:set(key_version, version)
            shard_policy:set(k, json_encode(policy))
        end
        if policy == nil then
            policy = shard_policy:get(k)
            policy = json_decode(policy)
        end
        policies[k] = policy
    end
    _M.policies = policies
end

return _M
