cat ddl/ARL_RFE.ddl | sed -e "s/;/;~/" -e 's/"//g' | tr -s "\n~" " \n" | grep "ALTER TABLE.*KEY" | tr -d '\15\32' | java -jar DDLParser.jar > ddl/ARL_RFE.ddl2

cat ddl/ARL_RFE.ddl | sed -e "s/;/;~/" -e 's/"//g' | tr -s "\n~" " \n" | grep "ALTER TABLE.*KEY" | tr -d '\15\32' | java -jar DDLParser2.jar > ddl/ARL_RFE.ddl3