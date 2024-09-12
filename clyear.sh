# closes the yearly transactions, updates master and reorganizes

clear
writecenter "Payroll Processing System" 2 "B"
writecenter "Close Year & Reorganize" 3 "B"

t=`tty`
oldifs="$IFS"

writecenter "Please wait... trying to close year" 10 "B"

yr=`date +%y`
if [ -f "etran$yr.dbf" ]
then
	writecenter "Year has already been closed. Press any key..." 12 "B"
	read key
	break
fi

#since financial year is from April to March
months="Apr:May:Jun:Jul:Aug:Sep:Oct:Nov:Dec:Jan:Feb:Mar"
IFS=:
set $months
count=1

flag=0
while [ $count -le 12 ]
do
	if [ -f "etran$1.dbf" ]
	then
		cat etran$1.dbf >> etran$yr.dbf
		rm etran$1.dbf
		flag=1
	fi

	count=`expr $count + 1`
	shift
done

if [ $flag -eq 0 ]
then
	writecenter "Month Has not been Closed. Press any key..." 12 "B"
	writecenter "Close month before closing year. Press any key..." 12 "B"
	read key
	break
fi

# set standard input to master file
exec < $MASTER

# prepare master file for new financial year

while read e_empcode e_empname e_sex e_address e_city e_pin e_dept e_grade e_gpf_no e_gis_no e_esis_no e_mac_cl e_max_pl e_max_ml e_bs e_cum_cl e_cum_pl e_cum_ml e_cum_lwp e_cum_att
do
	e_cum_cl=0
	e_cum_pl=0
	e_cum_ml=0
	e_cum_lwp=0
	e_cum_att=0

	echo $e_empcode:$e_empname:$e_sex:$e_address:$e_city:$e_pin:$e_dept:$e_grade:$e_gpf_no:$e_gis_no:$e_esis_no:$e_max_cl:$e_max_pl:$e_max_ml:$e_bs:$e_cum_cl:$e_cum_pl:$e_cum_ml:$e_cum_lwp:$e_cum_att >> /tmp/master
done

IFS="$oldifs"
mv /tmp/master $MASTER

# reset standard input to terminal
exec < $t
writecenter "Year has been closed successfully. Press any key..." 12 "B"
read key
break


	
