#!/bin/bash

# Where to restore
db_host='localhost'
db_name='adhoctuts'
db_user='root'
db_pass='Adhoctuts2018#'

dump_file='/root/dump_ignore.sql'

# Associative table list array as source_table=>destination_table pairs
declare -A tbl_list=( ["tbl1"]="restored_tbl1" ["tbl2"]="restored_tbl2")
	
for tbl in "${!tbl_list[@]}"
do
	echo "Restore $tbl to ${tbl_list[$tbl]}"
	# extract the content between drop table and Table structure for, also replace the table name
	sed -n -e '/DROP TABLE IF EXISTS `'$tbl'`/,/\/*!40000 ALTER TABLE `'$tbl'` ENABLE KEYS \*\/;/p' $dump_file > tbl.sql
	sed -i 's/`'$tbl'`/`'${tbl_list[$tbl]}'`/g' tbl.sql
	mysql -h $db_host -u $db_user -p"$db_pass" $db_name	< tbl.sql
	rm -f tbl.sql
done
