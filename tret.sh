# for retrieve the record from the transaction file..

another=y
while [ "$another" = y -o "$another" = Y ]
do
	clear
	writecenter "Payroll Processing System" 1 "B"
	writecenter "Retrieve Records - Transaction File" 2 "B"

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
tline=`echo $tline|tr '\t' ',' | tr ' ' ',' | tr -s ","`
IFS=','
       set -- $tline
echo $tline > /tmp/trans
        # if employee code already exists in transaction file 
        if [ -z $2 ]
        then
                writerc "Employee code does not exist. Press any key..." 10 10 "B"
                read key
                continue
	fi

	writerc "Dept: $2" 5 10 "N"
        writerc "Casual leave: $3" 6 10 "N"
        writerc "Medical leave: $4" 7 10 "N"
        writerc "Provisional leave: $5" 8 10 "N"
        writerc "LWP: $6" 9 10 "N"
        writerc "Special Pay 1: $7" 10 10 "N"
        writerc "Special pay 2: $8" 11 10 "N"
        writerc "Income Tax: $9" 12 10 "N"
        writerc "Rent ded: ${10}" 13 10 "N"
        writerc "Long term loan: ${11}" 14 10 "N"
        writerc "Short term loan: ${12}" 15 10 "N"
        writerc "Special deduction 1: ${13}" 16 10 "N"
        writerc "Special deduction 2: ${14}" 17 10 "N"
        t_da=${15}
        t_hra=${16}
        t_ca=${17}
        t_cca=${18}
        t_gpf=${19}
        t_esis=${20}
        t_gis=${21}
        t_prof_tax=${22}
        t_gs=${23}
        t_tot_ded=${24}
        t_net_pay=${25}
        writerc "Retrieve another y/n: " 20 20 "N"
        read another
        done

