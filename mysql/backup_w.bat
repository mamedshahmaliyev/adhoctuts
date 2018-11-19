@ECHO OFF
%= Define the database and root authorization details =% 
set db_host=192.168.70.138
set db_name=adhoctuts
set db_user=adhoctuts
set db_pass=Adhoctuts2018#

mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "select group_concat(concat('--ignore-table=',table_schema,'.',table_name)) into @tbl from information_schema.tables where table_schema='%db_name%' and table_name like '%%_log';select @tbl;" %db_name% > tbls

for /F "usebackq delims=" %%a in ("tbls") do (
    set space= 
	set str=%%a
	call set ignore=%%str:,=%space%%%
	
	mysqldump -h %db_host% -u %db_user% -p"%db_pass%" --skip-add-locks --skip-extended-insert %ignore% %db_name% > dump_ignore.sql
)

mysql -h %db_host% -u %db_user% -p"%db_pass%" -se "select group_concat(concat('--ignore-table=',table_schema,'.',table_name)) into @tbl from information_schema.tables where table_schema='%db_name%' and table_name like 'tbl1%%';select @tbl;" %db_name% > tbls

for /F "usebackq delims=" %%a in ("tbls") do (
    set space= 
	set str=%%a
	call set tbl_list=%%str:,=%space%%%
	
	mysqldump -h %db_host% -u %db_user% -p"%db_pass%" --skip-add-locks --skip-extended-insert %db_name% %tbl_list% > dump_tbl_only.sql
)

del /f tbls
