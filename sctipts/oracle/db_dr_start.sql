startup mount;
alter database recover managed standby database disconnect;
alter system set log_archive_dest_state_2=defer scope=both;
alter system set STANDBY_FILE_MANAGEMENT = AUTO scope = both;
alter system set log_archive_dest_state_2=enable;
exit;
