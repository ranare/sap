#!/usr/bin/ksh

. ~/.profile

rm -Rf $SAPDATA_HOME/sapdata1/oraarch_autohealing/`echo $LOGIN|cut -c1-3`arch*

CurrSCN=`sqlplus -s "/as sysdba" @/oracle/$DB_SID/scripts/primary_auto_current_logsqn.sql | awk '{print $NF}'| sort -k 3|tail -1 `
StarSCN=$(( CurrSCN - 100 ))

echo $CurrSCN
echo $StarSCN
echo "restore archivelog from logseq $StarSCN until logseq $CurrSCN;"

rman log=$SAPDATA_HOME/scripts/logs/primary_auto_restore_redolog.log append << EOF
#rman << EOF
connect target / ;
RUN {
ALLOCATE CHANNEL C1 DEVICE TYPE SBT_TAPE PARMS 'BLKSIZE=1048576, SBT_LIBRARY=/opt/dpsapps/dbappagent/lib/lib64/libddboostora.so, SBT_PARMS=(CONFIG_FILE=$ORACLE_HOME/dbs/ddboost.cfg)' FORMAT '%d_%U';
set archivelog destination to '$SAPDATA_HOME/sapdata1/oraarch_autohealing/`echo $LOGIN|cut -c1-3`arch';
restore archivelog from logseq $StarSCN until logseq $CurrSCN ;
RELEASE CHANNEL C1;
}
exit
EOF

