ngx.log(ngx.DEBUG, 'test start')
ngx.say('test', ngx.time())
ngx.log(ngx.DEBUG, 'test end')

local args = ngx.req.get_uri_args()

ngx.say(args.a)
