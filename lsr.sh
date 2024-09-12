# Generates leave status report.

clear
another=y
t=`tty`
month=`date +%B`
IFSspace="$IFS"

while [ "$another" = y -o "$another" = Y ]
do 
	clear
	writecenter "Payroll Processing System" 1 "B"
	writecenter "Leave Status Report" 2 "B"

	writerc "Employee Code: " 4 10 "B"
	read empcode

	if [ -z "$empcode" ]
	then 
		break
	fi

	mline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from emaster where employee_code='$empcode';
EOF
)
       set -- $mline

        grep  ^"$empcode": "$MASTER" > /dev/null 2>&1
        if [ $? -ne 0 ]
        then
                if [ -z "$1" ]
                then
                        writerc "Employee code does not exist, Press any key..." 10 10 "B"
                        read key
                        continue
                fi
        fi


	# calculate balance leaves
	bal_cl=`expr ${12} - ${16}`
	bal_ml=`expr ${14} - ${18}`
	bal_pl=`expr ${13} - ${17}`

	# diaplay leave status

	clear
	writecenter  "Payroll Processing System" 1 "B" 
	writecenter "Leave Status Report" 2 "B"

	writerc "\033[1mName:\033[0m $2" 5 1 "N"
	writerc "\033[1mEmpcode:\033[0m $1" 5 35 "N"
	writerc "\033[1mGrade:\033[0m $8" 5 55 "N"
	writerc "\033[1mMonth:\033[0m $month" 5 66 "N"

	writerc "CL Allowed" 7 1 "B"
	writerc "ML Allowed" 7 18 "B"
	writerc "PL Allowed" 7 35 "B"
	writerc "${12}" 8 1 "N"
	writerc "${14}" 8 18 "N"
	writerc "${13}" 8 35 "N"

	writerc "Cum.Cl" 10 1 "B"
	writerc "Cum.ML" 10 18 "B"
	writerc "Cum.PL" 10 35 "B"
	writerc "Cum.LWP" 10 55 "B"
	writerc "Cum.Att.Days" 10 66 "B"
	writerc "${16}" 11 1 "N"
	writerc "${18}" 11 18 "N"
	writerc "${17}" 11 35 "N"
	writerc "${19}" 11 55 "N"
	writerc "${20}" 11 66 "N"

	writerc "Balance CL" 13 1 "B"
	writerc "Balance ML" 13 18 "B"
	writerc "Balance PL" 13 35 "B"
	writerc "$bal_cl" 14 1 "N"
	writerc "$bal_ml" 14 18 "N"
	writerc "$bal_pl" 14 35 "N"

	writerc "Another employee y/n: " 20 10 "N"
	read another
done

