# prints monthly payslips for employees on SCREEN.

clear

writerc "Screen/printer " 10 20 "B"
read ans 

# calculate number of days in current month
month=`date +%B`
days="31 29 31 30 31 30 31 31 30 31 30 31"
tmp=`date +%m`
mdays=`echo $days | cut -d" " -f$tmp`

another=y
t=`tty`
IFSspace="$IFS"

while [ "$another" = y ]
do
	clear
	writerc "Employee code: " 4 10 "B"
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

	# build a horizontal dashed line
	din="-"
	count=0
	dln=`echo $2`
	while [ $count -lt 78 ]
	do
		din="$din-"
		count=`expr $count + 1`
	done

	clear
	writerc "$din" 0 1 "B"
	writecenter "Shivley & Brett Pvt. Ltd." 1 "B"
	writerc "$din" 2 1 "B"

	# display variousfield values at appropriate places
	writerc "Employee code:" 3 1 "B"
	writerc "$1" 3 15 "N"
	writerc "\033[1mSex:\033[0m $3" 3 24 "N"
	writerc "\033[1mGrade:\033[0m $8" 3 40 "N"
	writerc "\033[1mMonth:\033[0m $month" 3 66 "N"
	writerc "\033[1mName:\033[0m $2" 5 1 "N"
	writerc "\033[1mDepartment:\033[0m $7" 5 50 "N"
	writerc "\033[1mGPF NO.:\033[0m $9" 7 1 "N"
	writerc "\033[1mGIS NO.:\033[0m ${10}" 7 25 "N"
	writerc "\033[1mESIS NO.:\033[0m ${11}" 7 48 "N"
	writerc "BS" 12 1 "B"
	writerc "${15}" 13 1 "N"
	writerc "Attended Days" 9 66 "B"
	writerc "${20}" 10 66 "N"

tline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from etran where employee_code='$empcode';
EOF
)
       set -- $tline

	writerc "Normal Days" 9 1 "B"
	writerc "Casu.Leave" 9 20 "B"
	writerc "Medical Leave" 9 32 "B"
	writerc "Prov. Leave" 9 48 "B"
	writerc "LWP" 9 61 "B"
	writerc "$mdays" 10 1 "N"
	writerc "$3" 10 20 "N"
	writerc "$4" 10 32 "N"
	writerc "$5" 10 48 "N"
	writerc "$6" 10 61 "N"
	writerc "DA" 12 9 "B"
	writerc "HRA" 12 19 "B"
	writerc "CA" 12 29 "B"
	writerc "CCA" 12 38 "B"
	writerc "S.P.1" 12 48 "B"
	writerc "S.P.2" 12 57 "B"
	writerc "GS" 12 68 "B"
	writerc "${15}" 13 9 "N"
	writerc "${16}" 13 19 "N"
	writerc "${17}" 13 29 "N"
	writerc "${18}" 13 38 "N"
	writerc "$7" 13 48 "N"
	writerc "$8" 13 57 "N"
	writerc "${23}" 13 68 "N"
	writerc "GPF" 15 1 "B"
	writerc "ESIS" 15 10 "B"
	writerc "GIS" 15 18 "B"
	writerc "IT" 15 25 "B"
	writerc "PT" 15 32 "B"
	writerc "RENT" 15 39 "B"
	writerc "Loan1" 15 48 "B"
	writerc "Loan2" 15 54 "B"
	writerc "S.D.1" 15 61 "B"
	writerc "S.D.2" 15 68 "B"
	writerc "Total" 15 74 "B"
	writerc "${19}" 16 1 "N"
	writerc "${20}" 16 10 "N"
	writerc "${21}" 16 18 "N"
	writerc "$9" 16 25 "N"
	writerc "${22}" 16 32 "N"
	writerc "${10}" 16 39 "N"
	writerc "${11}" 16 48 "N"
	writerc "${12}" 16 54 "N"
	writerc "${13}" 16 61 "N"
	writerc "${14}" 16 68 "N"
	writerc "${24}" 16 74 "N"
	writerc "Net Pay" 18 1 "B"
	writerc "Rs.${25}" 19 1 "N"
	writerc "Receiver's Signature" 18 59 "B"
	writerc "$dln" 19 66 "N"

	writerc "Want to display another payslip y/n: " 22 17 "N"
	read another
done





