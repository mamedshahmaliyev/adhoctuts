%= https://adhoctuts.com/mysql-selective-exceptional-permissions-and-backup-restore/ =% 
%= https://youtu.be/8fWQbtIISdc =% 

%= Define the database and root authorization details =% 
@ECHO OFF
SETLOCAL EnableDelayedExpansion

set db_host=192.168.70.138
set db_name=adhoctuts
set db_user=adhoctuts
set db_pass=Adhoctuts2018#

set dump_file=dump_ignore.sql

set tbl_cnt=2
set source_table[1]=tbl1
set destination_table[1]=restored_tbl1
set source_table[2]=tbl2
set destination_table[2]=restored_tbl2

set i=1
:loop	
	set src=!source_table[%i%]!
	set dest=!destination_table[%i%]!
	for /f "tokens=1 delims=[]" %%a in ('find /n "DROP TABLE IF EXISTS `%src%`"^<"%dump_file%"') do set /a start=%%a
	for /f "tokens=1 delims=[]" %%a in ('find /n "ALTER TABLE `%src%` ENABLE KEYS"^<"%dump_file%"') do set /a end=%%a
	(
	for /f "tokens=1* delims=[]" %%a in ('find /n /v ""^<"%dump_file%"') do (
	
	set "line=%%b "
	 IF %%a geq %start% IF %%a leq %end% ECHO( !line:%src%=%dest%!
	 )
	)>"tbl.sql"
	
	mysql -h %db_host% -u %db_user% -p"%db_pass%" %db_name%	< "tbl.sql"
	del /f "tbl.sql"
	if %i% equ %tbl_cnt% goto :eof
	set /a i=%i%+1
goto loop
