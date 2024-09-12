# for delete the record from the transaction file..

clear
another=y

while [ "$another" = y -o "$another" = Y ]
do
	writecenter "Payroll Processing System" 1 "B"
	writecenter "Deletes Records - Transaction File" 2 "B"

	writerc "Employee code: " 4 10 "B"
	read t_empcode
	if [ -z $t_empcode ]
	then
		break
	fi

tline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from etran where employee_code='$t_empcode';
EOF
)
       set --$tline

        # if employee code already exists in transaction file 
        if [ ! "$1" == "$t_empcode" ]
        then
                writerc "Employee code does not exist. Press any key..." 10 10 "B"
                read key
                continue
        fi

  	grep -vi ^$t_empcode $TRAN > /tmp/etran.ddd
	mv /tmp/etran.ddd $TRAN

sqlplus -S hr/123456 << EOF > /dev/null
set heading off;
delete etran where employee_code=$t_empcode;
commit;
EOF

	writerc "Delete another y/n: " 12 10 "B"
	read another
done



