#!/bin/ksh

TS_FREE_GB_TRESHLOLD=400
SAPDATA1_FREE_PERCENT_TRESHOLD=94
SAPDATA3_FREE_PERCENT_TRESHOLD=94
SAPDATA4_FREE_PERCENT_TRESHOLD=98
SAPDATA_FREE_MB_TRESHOLD=35


SID=$DB_SID
TABLESPACE=PSAPSR3

MESSAGE_1="Enough free space in tablespace"
MESSAGE_2="Not enough free space in tablespace"

SAPDATA1_FREE_MB=`df -g -F '%f' /oracle/$SID/sapdata1  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`
SAPDATA1_FREE_PERCENT=`df -g -F '%z' /oracle/$SID/sapdata1  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`

SAPDATA2_FREE_MB=`df -g -F '%f' /oracle/$SID/sapdata2  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`
SAPDATA2_FREE_PERCENT=`df -g -F '%z' /oracle/$SID/sapdata2  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`

SAPDATA3_FREE_MB=`df -g -F '%f' /oracle/$SID/sapdata3  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`
SAPDATA3_FREE_PERCENT=`df -g -F '%z' /oracle/$SID/sapdata3  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`


SAPDATA4_FREE_MB=`df -g -F '%f' /oracle/$SID/sapdata4  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`
SAPDATA4_FREE_PERCENT=`df -g -F '%z' /oracle/$SID/sapdata4  | grep -v Filesystem |  sort -k 3 | tail  -1 | awk '{a=$3}END{gsub("%", "", a);printf "%.0f\n",a}'`


SAPDATA_MOST_MB=`df -g /oracle/$SID/sapdata* | grep -v Filesystem |  sort -k 3 | tail  -1 | tail -c 2`

TS_FREE_GB=`sqlplus -s "/ as sysdba" <<END
SET HEADING OFF
Select round(sum(bytes)/1024/1024/1024 ,0)  Free_space_MB from dba_free_space where tablespace_name='$TABLESPACE';
exit;
END |  awk '{print $NF}'`

print "############################## START                                     "

print "TS_FREE_GB_TRESHLOLD=$TS_FREE_GB_TRESHLOLD"
print "TS_FREE_GB=$TS_FREE_GB"
print "SAPDATA_FREE_PERCENT_TRESHOLD=$SAPDATA_FREE_PERCENT_TRESHOLD"

print "SAPDATA1_FREE_PERCENT=$SAPDATA1_FREE_PERCENT"
print "SAPDATA3_FREE_PERCENT=$SAPDATA3_FREE_PERCENT"
print "SAPDATA4_FREE_PERCENT=$SAPDATA4_FREE_PERCENT"



print "SAPDATA_FREE_MB_TRESHOLD=$SAPDATA_FREE_MB_TRESHOLD"
print "SAPDATA_FREE_MB = $SAPDATA_FREE_MB"



#if [  $TS_FREE_GB -ge  $TS_FREE_GB_TRESHLOLD ] ; then
if [  $TS_FREE_GB_TRESHLOLD -ge  $TS_FREE_GB ] && [ $SAPDATA1_FREE_PERCENT_TRESHOLD -ge $SAPDATA1_FREE_PERCENT ] && [ $SAPDATA1_FREE_MB -ge $SAPDATA_FREE_MB_TRESHOLD ]; then

#echo $TS_FREE_GB
#echo $SAPDATA_FREE_PERCENT
#echo $SAPDATA_FREE_MB = $SAPDATA_FREE_MB"
print "TS_FREE_GB=$TS_FREE_GB"
print "SAPDATA_FREE_PERCENT=$SAPDATA_FREE_PERCENT"
print "SAPDATA_FREE_MB = $SAPDATA_FREE_MB"

echo $MESSAGE_2
print "Extend on sapdata 1"
brspace  -confirm force -function tsextend -tablespace $TABLESPACE -f 1 -maxsize 0

#elif [  $TS_FREE_GB_TRESHLOLD -ge  $TS_FREE_GB ] && [ $SAPDATA_FREE_PERCENT_TRESHOLD -ge $SAPDATA2_FREE_PERCENT ] && [ $SAPDATA2_FREE_MB -ge $SAPDATA_FREE_MB_TRESHOLD ]; then

#echo $TS_FREE_GB
#echo $SAPDATA_FREE_PERCENT
#echo $SAPDATA_FREE_MB = $SAPDATA_FREE_MB"
#print "TS_FREE_GB=$TS_FREE_GB"
#print "SAPDATA_FREE_PERCENT=$SAPDATA_FREE_PERCENT"
#print "SAPDATA_FREE_MB = $SAPDATA_FREE_MB"

#echo $MESSAGE_2
#brspace  -confirm force -function tsextend -tablespace $TABLESPACE -f 2 -maxsize 0

elif [  $TS_FREE_GB_TRESHLOLD -ge  $TS_FREE_GB ] && [ $SAPDATA3_FREE_PERCENT_TRESHOLD -ge $SAPDATA3_FREE_PERCENT ] && [ $SAPDATA3_FREE_MB -ge $SAPDATA_FREE_MB_TRESHOLD ]; then

#echo $TS_FREE_GB
#echo $SAPDATA_FREE_PERCENT
#echo $SAPDATA_FREE_MB = $SAPDATA_FREE_MB"
print "TS_FREE_GB=$TS_FREE_GB"
print "SAPDATA_FREE_PERCENT=$SAPDATA_FREE_PERCENT"
print "SAPDATA_FREE_MB = $SAPDATA_FREE_MB"

echo $MESSAGE_2
print "Extend on sapdata 3"
brspace  -confirm force -function tsextend -tablespace $TABLESPACE -f 3 -maxsize 0

elif [  $TS_FREE_GB_TRESHLOLD -ge  $TS_FREE_GB ] && [ $SAPDATA4_FREE_PERCENT_TRESHOLD -ge $SAPDATA4_FREE_PERCENT ] && [ $SAPDATA4_FREE_MB -ge $SAPDATA_FREE_MB_TRESHOLD ]; then

#echo $TS_FREE_GB
#echo $SAPDATA_FREE_PERCENT
#echo $SAPDATA_FREE_MB = $SAPDATA_FREE_MB"
print "TS_FREE_GB=$TS_FREE_GB"
print "SAPDATA_FREE_PERCENT=$SAPDATA_FREE_PERCENT"
print "SAPDATA_FREE_MB = $SAPDATA_FREE_MB"

echo $MESSAGE_2
print "Extend on sapdata 4"
brspace  -confirm force -function tsextend -tablespace $TABLESPACE -f 4 -maxsize 0

else
print "###################### Results "
print "Checked on all sapdata "
print "Tablespace free GB    (TS_FREE_GB)           = $TS_FREE_GB \n"
print "Sapdata free percetnn (SAPDATA_FREE_PERCENT) = $SAPDATA_FREE_PERCENT \n"
print "Sapdata free MB       (SAPDATA_FREE_MB     ) = $SAPDATA_FREE_MB \n"

echo $TS_FREE_GB
echo $MESSAGE_1

fi
