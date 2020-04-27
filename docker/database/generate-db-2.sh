mysql_upgrade -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD realmd < /opt/vmangos/sql/logon.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD logs < /opt/vmangos/sql/logs.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD characters < /opt/vmangos/sql/characters.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD mangos < /opt/vmangos/sql/database/$world.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD mangos < /opt/vmangos/sql/migrations/world_db_updates.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD characters < /opt/vmangos/sql/migrations/characters_db_updates.sql
mysql -u root -h 127.0.0.1 -p$MYSQL_ROOT_PASSWORD -e "INSERT INTO realmd.realmlist (name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, gamebuild_min, gamebuild_max, flag, realmbuilds) VALUES ('$realm_name', '$realm_ip', '$realm_port', '$realm_icon', '$realmflags', '$timezone', '$allowedSecurityLevel', '$population', '$gamebuild_min', '$gamebuild_max', '$flag','');"
