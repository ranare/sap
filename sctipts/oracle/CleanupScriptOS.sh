#!/usr/bin/ksh

#delete all audit files older than 20 days
find $SAPDATA_HOME/saptrace/audit -name "*_*.aud" -type f -mtime +20 -exec ls -la {} \;
find $SAPDATA_HOME/saptrace/audit -name "*_*.aud" -type f -mtime +20 -exec rm -Rf {} \;
