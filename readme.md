## Simple WAF ##

部署

1. 使用openresty或者ngx_lua web服务器

2. 参看 conf/nginx.conf 将配置waf_http.conf和waf_server.conf配置在web服务器中

3. 将 datas, lua部署到nginx启动prefix路径下

4. 将www/waf部署到nginx root目录

5. 访问 http://ip:port/waf/
