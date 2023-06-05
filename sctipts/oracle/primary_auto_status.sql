archive log list;

set line 300
col dest_name for a20
col destination for a20
col error for a40
col db_unique_name for a20
SELECT DATABASE_ROLE, DB_UNIQUE_NAME INSTANCE, OPEN_MODE, PROTECTION_MODE, PROTECTION_LEVEL, SWITCHOVER_STATUS FROM V$DATABASE;
SELECT MESSAGE FROM V$DATAGUARD_STATUS;
SELECT THREAD#, MAX(SEQUENCE#) AS "LAST_APPLIED_LOG" FROM V$LOG_HISTORY GROUP BY THREAD# order by 1;
select dest_name, status, target , destination, reopen_secs, fail_date, fail_sequence, max_failure, error, transmit_mode, type, db_unique_name, verify from v$archive_dest where status!='INACTIVE';

exit;
