#!/bin/bash

# https://adhoctuts.com/mysql-selective-exceptional-permissions-and-backup-restore/ 
# https://youtu.be/8fWQbtIISdc

# Define the database and root authorization details
db_host='localhost'
db_name='adhoctuts'
db_user='root'
db_pass='Adhoctuts2018#'

# Define the ignore list
tmp=$(mysql -h $db_host -u $db_user -p"$db_pass" -se "select group_concat(concat(' --ignore-table=',table_schema,'.',table_name)) into @tbl from information_schema.tables where table_schema='$db_name' and table_name like '%_log';select @tbl;" $db_name | cut -f1)
ignore=${tmp//,/""}
mysqldump -h $db_host -u $db_user -p"$db_pass" --skip-add-locks --skip-extended-insert $ignore $db_name > dump_ignore.sql

# Define the table list using the same logic
tmp=$(mysql -h $db_host -u $db_user -p"$db_pass" -se "select group_concat(concat(' ',table_name)) into @tbl from information_schema.tables where table_schema='$db_name' and table_name like 'tbl1%';select @tbl;" $db_name | cut -f1)
tbl_list=${tmp//,/""}
mysqldump -h $db_host -u $db_user -p"$db_pass" --skip-add-locks --skip-extended-insert $db_name $tbl_list > dump_tbl_only.sql
