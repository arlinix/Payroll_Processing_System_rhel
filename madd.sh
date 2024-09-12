# madd.prg
# Adds new records to master file.

another=y
t=`tty`

while [ "$another" = y -o "$another" = Y ]
do
	clear
	writecenter "Payroll Processing System" 1 "B"
	writecenter "Add Records - Master File" 2 "B"

	writerc "Employee Code: \c" 4 10 "B"
	read e_empcode
	if [ -z "$e_empcode" ]
	then
		break
	fi

mline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select employee_code from emaster where employee_code='$e_empcode';
EOF
)
#echo $mline > /tmp/tadd


#grep ^$e_empcode $MASTER > /dev/null
#if [ $? -eq 0 ]
#then

        	if [ `echo $mline` -eq `echo $e_empcode` ] > /dev/null 2>&1
        	then
                writerc "Code already exists. Press any key.." 20 10 "N"
                read key
                continue
  	        fi
#fi

	# read values of various feilds
	writerc "Name of Employee: \c" 5 10 "B"
	read e_empname 
	writerc "Sex: \c" 6 10 "B"
	read e_sex
	writerc "Address: \c" 7 10 "B"
	read e_address
	writerc "Name of city: \c" 8 10 "B"
	read e_city
	writerc "Pin code number: \c" 9 10 "B"
	read e_pin
	writerc "Department(mfg/assly/stores/accts/maint): \c" 10 10 "B"
	read e_dept
	writerc "Grade(ssk/hsk/ski/sms/usk): \c" 11 10 "B"
	read e_grade
	writerc "GPF no. : \c" 12 10 "B"
	read e_gpf_no
	writerc "GI scheme no. : \c" 13 10 "B"
	read e_gis_no
	writerc "ESI scheme no. : \c" 14 10 "B"
	read e_esis_no 
	writerc "CL allowed: \c" 15 10 "B"
	read e_max_cl
	writerc "PL allowed: \c" 16 10 "B"
	read e_max_pl
	writerc "ML allowed: \c" 17 10 "B"
	read e_max_ml
	writerc "Basic Salary: \c" 18 10 "B"
	read e_bs

	e_cum_cl=0
	e_cum_pl=0
	e_cum_ml=0
	e_cum_lwp=0
	e_cum_att=0

	# write new record into empioyee master file

sqlplus -S hr/123456 << EOF
set feedback off;
insert into emaster values ('$e_empcode', '$e_empname', '$e_sex', '$e_address', '$e_city', $e_pin, '$e_dept', '$e_grade', $e_gpf_no, $e_gis_no, $e_esis_no, $e_max_cl, $e_max_pl, $e_max_ml, $e_bs, $e_cum_cl, $e_cum_pl, $e_cum_ml, $e_cum_lwp, $e_cum_att );
commit;
EOF

	echo $e_empcode:$e_empname:$e_sex:$e_address:$e_city:$e_pin:$e_dept:$e_grade:$e_gpf_no:$e_gis_no:$e_esis_no:$e_max_cl:$e_max_pl:$e_max_ml:$e_bs:$e_cum_cl:$e_cum_pl:$e_cum_ml:$e_cum_lwp:$e_cum_att | dd conv=ucase 2>/dev/null>>$MASTER
	
	writerc "Add another y/n: \c" 20 10 "N"
read another
done

