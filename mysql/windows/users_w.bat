%= https://adhoctuts.com/mysql-selective-exceptional-permissions-and-backup-restore/ =% 
%= https://youtu.be/8fWQbtIISdc =% 

@ECHO OFF
%= Define the database and root authorization details =% 
set db_host=192.168.70.138
set db_name=adhoctuts
set db_user=adhoctuts
set db_pass=Adhoctuts2018#

mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "select concat(table_schema,'.',table_name) from information_schema.tables where table_schema='%db_name%' and table_name not like 'tbl1' AND table_name not like '\_\_%%';" %db_name% > tbls

setlocal EnableDelayedExpansion
set user_cnt=2
set user[1]='Adhoctuts1'@'192.168.%%.%%'
set pass[1]=Adhoctuts1_2018#
set user[2]='Adhoctuts2'@'192.168.%%.%%'
set pass[2]=Adhoctuts2_2018#

set i=1
:loop
	set user=!user[%i%]!
	set pass=!pass[%i%]!
	mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "drop user if exists %user% ; create user %user%  identified by '%pass%';"
	mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "revoke all privileges, grant option from %user%;" %db_name%		
	for /F "usebackq delims=" %%a in ("tbls") do (
		mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "grant select on %%a TO %user%;" %db_name%
	)
	if %i% equ %user_cnt% goto :end_loop
	set /a i=%i%+1
goto loop

:end_loop
del /f tbls
