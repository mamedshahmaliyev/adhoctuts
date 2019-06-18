#!/bin/bash

# https://adhoctuts.com/mysql-selective-exceptional-permissions-and-backup-restore/ 
# https://youtu.be/8fWQbtIISdc

# Define the database and root authorization details
db_host='localhost'
db_name='adhoctuts'
db_user='root'
db_pass='Adhoctuts2018#'

# Define the query to get the needed tables
table_list=$(mysql -h $db_host -u $db_user -p"$db_pass" -se "select concat(table_schema,'.',table_name) from information_schema.tables where table_schema='$db_name' and table_name not like 'tbl1' AND table_name not like '\_\_%';" $db_name | cut -f1)

# Convert the query result into the array
table_arr=(${table_list//,/ })

# Declare the associative array of the users as username=>password pair
# e.g: declare -A user_list=(["'user1'"]="pass1" ["'user2'"]="pass2")
# In our case there is a single user
declare -A user_list=(["'aht_r'@'localhost'"]="Adhoctuts2018#")
for user in "${!user_list[@]}"
do
	pass=${user_list[$user]}
	# Recreate user
	mysql -h $db_host -u $db_user -p"$db_pass" -se "drop user if exists $user; create user $user identified by '$pass';"
	
	# Provide SELECT privilege
	mysql -h $db_host -u $db_user -p"$db_pass" -se "revoke all privileges, grant option from $user;" $db_name
	mysql -h $db_host -u $db_user -p"$db_pass" -se "grant usage on $db_name.* TO $user;" $db_name
	for tbl in "${table_arr[@]}"; do
	    echo "grant select on $tbl TO $user"
		mysql -h $db_host -u $db_user -p"$db_pass" -se "grant select on $tbl TO $user;" $db_name	
	done
done
