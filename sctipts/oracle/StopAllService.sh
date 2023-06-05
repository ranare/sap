#!/usr/bin/ksh

psup=$(ps -ef | grep pmon | egrep -v grep | wc -l)

if  [ "$psup" -gt 0 ]
then

   echo "Oracle is running need to stop it"
   kill -9 `ps -ef | grep pmon | grep -v grep |  awk '{ print $2 }'`
else

   echo  "Process pmon is not runnung"

fi

sleep 10

sapcontrol -nr 0 -function StopService
sapcontrol -nr 1 -function StopService

for i in `ipcs -s | grep $USER | awk '{ print $2 }'`
do
echo $i
ipcrm -s $i
done


for i in `ipcs -m | grep $USER | awk '{ print $2 }'`
do
echo $i
ipcrm -m $i
done

