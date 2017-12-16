## Simple WAF ##

部署

1. 使用openresty或者ngx_lua web服务器

2. 参看conf/nginx.conf配置waf_http.conf和waf_server.conf到web服务器中

3. 将 datas, lua部署到nginx启动prefix路径下

4. 将www/waf部署到nginx root目录

5. 访问 http://ip:port/waf/
