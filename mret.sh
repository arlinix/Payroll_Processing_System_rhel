# Retreives record from master file and display it on screen

another=y

while [ "$another" = y -o "another" = Y ]
do
	clear
	writecenter "Payroll maintenance System" 1 "B"
	writecenter "Retrieve Records - Master File" 2 "B"

	writerc "Employee Code: " 4 10 "B"
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
        select * from emaster where employee_code=$e_empcode;
EOF
)
echo $mline > /tmp/test1
#mline=`echo $mline|tr '\t' ',' | tr ' ' ',' | tr -s ","`
#IFS=','
        set -- $mline
#echo $1 > /tmp/temp

        # if employee doesnot exist
        if [  -z "$1" ]
        then
		writerc "Employee code does not exist. Press any key..." 10 10 "B"
                read key
                continue
	fi
	writerc "Name: $2" 5 10 "N"
        writerc "sex: $3" 6 10 "N"
        writerc "Address: $4" 7 10 "N"
        writerc "City: $5" 8 10 "N"
        writerc "Pin code: $6" 9 10 "N"
        writerc "Department: $7" 10 10 "N"
        writerc "Grade: $8" 11 10 "N"
        writerc "GPF no: $9" 12 10 "N"
        writerc "GI scheme no: ${10}" 13 10 "N"
        writerc "ESI sscheme: ${11}" 14 10 "N"
        writerc "CL allowed: ${12}" 15 10 "N"
        writerc "PL allowed: ${13}" 16 10 "N"
        writerc "ML allowed: ${14}" 17 10 "N"
        writerc "Basic salary: ${15}" 18 10 "N"

	writerc "Retrieve another y/n: " 20 20 "N"
	read another
	done



