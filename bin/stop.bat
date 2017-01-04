@echo off

setlocal

cd ..

set HOME=%cd%
set NGINX_HOME=%HOME%/../nginx
set NGINX=%NGINX_HOME%/nginx.exe

%NGINX% -s stop
taskkill /F /IM nginx.exe
endlocal
