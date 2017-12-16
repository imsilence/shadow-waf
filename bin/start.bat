@echo off

setlocal
cd ..

set HOME=%cd%
set NGINX_HOME=%HOME%/../nginx
set NGINX=%NGINX_HOME%/nginx.exe
set NGINX_CONF=%HOME%/conf/nginx.conf

echo WORKON:%HOME%
start %NGINX% -p %HOME% -c %NGINX_CONF%

endlocal
