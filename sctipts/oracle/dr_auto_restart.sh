#!/usr/bin/ksh

sqlplus / as sysdba @/oracle/$DB_SID/scripts/db_dr_stop.sql
lsnrctl stop
sleep 100

/oracle/$DB_SID/scripts/StopAllService.sh

lsnrctl start
sqlplus / as sysdba @/oracle/$DB_SID/scripts/db_dr_start.sql
sleep 100
sqlplus / as sysdba @/oracle/$DB_SID/scripts/db_status.sql
sleep 200
sqlplus / as sysdba @/oracle/$DB_SID/scripts/db_dr_status_log.sql

tail -3000 /oracle/$DB_SID/saptrace/diag/rdbms/`echo $LOGIN|cut -c1-3`dr/$DB_SID/trace/alert_$DB_SID.log | grep GAP | tail -1
tail -10000 /oracle/$DB_SID/saptrace/diag/rdbms/`echo $LOGIN|cut -c1-3`dr/$DB_SID/trace/alert_$DB_SID.log | grep GAP | awk '{print $NF}' | sed 's/-/ /' | tail -1 |  awk '{print $1}'
