#!/usr/bin/ksh

sqlplus / as sysdba @/oracle/$DB_SID/scripts/primary_auto_status.sql

sqlplus / as sysdba @/oracle/$DB_SID/scripts/primary_auto_enable.sql

#tail -50 /oracle/$DB_SID/saptrace/diag/rdbms/`echo $LOGIN|cut -c1-3`/$DB_SID/trace/alert_$DB_SID.log

#restore last 200 redolgs and delte old redolgs in same directory
/oracle/$DB_SID/scripts/primary_auto_restore_redolog.sh
