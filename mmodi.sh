# Modifies an existing record in master file

oldIFS="$IFS"
another=y
while [ "$another" == "y" -o "$another" == "Y" ]
do
        clear
        writecenter "Payroll Processing System" 1 "B"
        writecenter "Modify Records - Master File" 2 "B"
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
#echo $mline > /tmp/mmodi.txt
#mline=`echo $mline|tr '\t' ',' | tr ' ' ',' | tr -s ","`
#IFS=','

       set -- $mline
#echo $1 > /tmp/temp

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

        writerc "Name:$2 " 5 10 "N"
        read empname
        if [ -z "$empname" ]
        then
                empname=$2
        fi

        writerc "sex:$3 " 6 10 "N"
        read sex
        if [ -z "$sex" ]
        then
                sex=$3
        fi

        writerc "Address:$4 " 7 10 "N"
        read address
        if [ -z "$address" ]
        then
                address=$4
        fi

        writerc "City:$5 " 8 10 "N"
        read city
        if [ -z "$city" ]
        then
                city=$5
        fi

        writerc "Pin code No:$6 " 9 10 "N"
        read pin
        if [ -z "$pin" ]
        then
                pin=$6
        fi

        writerc "Department:$7 " 10 10 "N"
        read dept
        if [ -z "$dept" ]
        then
                dept=$7
        fi

        writerc "Grade:$8 " 11 10 "N"
        read grade
        if [ -z "$grade" ]
        then
                grade=$8
        fi

        writerc "GPF no:$9 " 12 10 "N"
        read gpf_no
        if [ -z "$gpf_no" ]
        then
                gpf_no=$9
        fi

        writerc "GI scheme no:${10} " 13 10 "N"
        read gis_no
        if [ -z "$gis_no" ]
        then
                gis_no=${10}
        fi

        writerc "ESI sscheme no:${11} " 14 10 "N"
        read esis_no
        if [ -z "$esis_no" ]
        then
                esis_no=${11}
        fi

        writerc "CL allowed:${12} " 15 10 "N"
        read max_cl
        if [ -z "$max_cl" ]
        then
                max_cl=${12}
        fi

        writerc "PL allowed:${13} " 16 10 "N"
        read max_pl
        if [ -z "$max_pl" ]
        then
                max_pl=${13}
        fi

        writerc "ML allowed:${14} " 17 10 "N"
        read max_ml
        if [ -z "$max_ml" ]
        then
                max_ml=${14}
        fi

        writerc "Basic salary:${15} " 18 10 "N"
        read bs
        if [ -z "$bs" ]
        then
                bs=${15}
        fi

        cum_cl=${16}
        cum_pl=${17}
        cum_ml=${18}
        cum_lwp=${19}
        cum_att=${20}

        IFS="$oldIFS"

        # append modified record to employee master file

sqlplus -S hr/123456 << EOF
set feedback off;
update emaster
set
Name_of_Employee = '$empname',Sex = '$sex',Address = '$address',City = '$city',Pincode = $pin,Department = '$dept',Grade = '$grade',GPF_No = $gpf_no,GI_Scheme_No = $gis_no,ESI_Scheme_No = $esis_no,CL_Allowed = $max_cl,PL_Allowed = $max_pl,ML_Allowed = $max_ml,Basic_Salary = $bs,E_Cum_Cl = $cum_cl,E_Cum_Pl = $cum_pl,E_Cum_Ml = $cum_ml,E_Cum_Lwp = $cum_lwp,E_Cum_Att = $cum_att
where Employee_Code = '$empcode';
commit;
EOF

        echo "$empcode":"$empname":"$sex":"$address":"$city":"$pin":"$dept":"$grade":"$gpf_no":"$gis_no":"$esis_no":"$max_cl":"$max_pl":"$max_ml":"$bs":"$cum_cl":"$cum_pl":"$cum_ml":"$cum_lwp":"$cum_att" | dd conv=ucase 2>/dev/null>>/tmp/emaster.mmm
        
	# move new master over top of original
        mv /tmp/emaster.mmm "$MASTER"
        writerc "Modify Another y/n: " 20 20 "N"
        read another
        done



