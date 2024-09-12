#set -vx
# tadd.prg
# Adds new records to empolyee transaction file.
oldIFS="$IFS"
clear
another=y
t=`tty`

	# percentage used for calculation, according to empolyee grade
	ssk="200 30 10 10 10 75 115 20"
	hsk="200 25 10 10 10 75 115 20"
	ski="100 25 10 10 10 75 115 15"
	sms="100 22 10 10 10 75 115 15"
	usk="17 20 10 10 10 75 115 0"

	while [ "$another" = y -o "$another" = Y ]
	do
		clear
		writecenter "Payroll Processing System" 1 "B"
		writecenter "Add Records - Transaction File" 2 "B"

		writerc "Employee Code: " 4 10 "B"
		read t_empcode
	if [ -z "$t_empcode" ]
	then
		break
	fi

mline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from emaster where employee_code='$t_empcode';
EOF
)
#echo $mline > /tmp/tadd.txt
#mline=`echo $mline|tr '\t' ',' | tr ' ' ',' | tr -s ","` 
#IFS=","
#echo $mline > /tmp/temp

	 set -- $mline
#echo $1 $2 $3 > /tmp/args
#	 grep ^$t_empcode $MASTER > /dev/null
#	 if [ $? -ne 0 ]
 #        then
		if [ -z $1 ]
        	then
                writecenter "Corresponding Master record absent" 7 "N"
                writecenter "Press any key..." 8 "N"
                read key
                continue
  	        fi
#	fi

#IFS="$oldIFS"

        tline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from etran where employee_code='$t_empcode';
EOF
)
#tline=`echo $tline|tr '\t' ',' | tr ' ' ',' | tr -s ","`
#IFS=' '
       set -- $tline
echo $tline > /tmp/tadd.est


        
#        grep ^$t_empcode: $TRAN > /dev/null
 #       if [ $? -eq 0 ]
  #      then
		if [ `echo $1` -eq `echo $t_empcode` ] > /dev/null 2>&1
       	 	then
                writecenter "Already exists, Cannot duplicate" 7 "N"
                writecenter "Press any key..." 8 "N"
                read key
                continue
        	fi
 #	fi

	# read values of various fields
	writerc "Department: " 5 10 "B"
	read t_dept
	writerc "Casual leave: " 6 10 "B"
	read t_cl
	writerc "Medical leave: " 7 10 "B"
	read t_ml
	writerc "Provisional leave: " 8 10 "B"
	read t_pl
	writerc "LWP: " 9 10 "B"
	read t_lwp
	writerc "Special pay 1: " 10 10 "B"
	read t_sppay_1
	writerc "Special pay 2: " 11 10 "B"
	read t_sppay_2
	writerc "Income tax: " 12 10 "B"
	read t_inc_tax
	writerc "Rent deduction: " 13 10 "B"
	read t_rent_ded
	writerc "Long term loan: " 14 10 "B"
	read t_lt_loan
	writerc "Short term loan: " 15 10 "B"
	read t_st_loan
	writerc "Special ded 1: " 16 10 "B"
	read t_spded_1
	writerc "Special ded 2: " 17 10 "B"
	read t_spded_2

#echo $* > /tmp/tline


	# extract grade and basic salary from master
	set -- $mline
#echo $* > /tmp/mline
	grade=`echo $mline | cut -d " " -f8`
	grade=${grade,,}
echo $grade > /tmp/grade
	bs=`echo $mline | cut -d " " -f15`
echo $bs > /tmp/bs

	# calulate various allowances and gross salary
	#IFS=$oldIFS
	        set -- `eval echo \\$$grade`
echo $* > /tmp/gradesss
	t_da=`echo -e "scale=2; $1 / 100 * $bs"|bc`
	t_hra=`echo -e "scale=2; $2 / 100 * $bs"|bc`
	t_ca=`echo -e "scale=2; $3 / 100 * $bs"|bc`
	t_cca=`echo -e "scale=2; $4 / 100 * $bs"|bc`
	t_gs=`echo -e "scale=2; $bs + $t_da + $t_hra + $t_ca + $t_cca + $t_sppay_1 + $t_sppay_2"|bc`

	# calculate various deductions
	t_gpf=`echo -e "scale=2; $5 / 100 * ( $bs + $t_da )" |bc`
	t_esis=$6
	t_gis=$7
	t_prof_tax=$8
	t_tot_ded=`echo -e "scale=2; $t_gpf + $t_esis + $t_gis + $t_prof_tax + $t_inc_tax + $t_lt_loan + $t_st_loan + $t_rent_ded + $t_spded_1 + $t_spded_2"|bc`

	#calculate net salary
	t_net_pay=`echo -e "scale=2; $t_gs - $t_tot_ded" | bc`

	# write new record to transaction file

	#IFS=','
sqlplus -S hr/123456 << EOF
set feedback off;
insert into etran values($t_empcode,'$t_dept',$t_cl,$t_ml,$t_pl,$t_lwp,$t_sppay_1,$t_sppay_2,$t_inc_tax,$t_rent_ded,$t_lt_loan,$t_st_loan,$t_spded_1,$t_spded_2,$t_da,$t_hra,$t_ca,$t_cca,$t_gpf,$t_esis,$t_gis,$t_prof_tax,$t_gs,$t_tot_ded,$t_net_pay);
commit;
EOF

	echo $t_empcode:$t_dept:$t_cl:$t_ml:$t_pl:$t_lwp:$t_da:$t_hra:$t_ca:$t_cca:$t_sppay_1:$t_sppay_2:$t_gs:$t_gpf:$t_gis:$t_esis:$t_inc_tax:$t_prof_tax:$t_rent_ded:$t_lt_loan:$t_st_loan:$t_spded_1:$t_spded_2:$t_tot_ded:$t_net_pay | dd conv=ucase 2>/dev/null>>$TRAN
	
	# find number of days in current month
	days="31 28 31 30 31 30 31 31 30 31 30 31"
	months=`date +%m`
	totdays=`echo $days | cut -d " " -f$months`

mline=$(sqlplus -S hr/123456 << EOF
set heading off;
set feedback off;
set pagesize 0;
set linesize 1000;
select * from emaster where employee_code='$t_empcode';
EOF
)

#mline=`echo $mline|tr '\t' ',' | tr ' ' ',' | tr -s ","`
#IFS=','
        set -- $mline

	if [ `echo $1` -eq `echo $t_empcode` ] >/dev/null 2>&1
	then
		# update cumulative leaves fields
		cl=$(expr 0  + $t_cl)
		ml=$(expr 0 + $t_ml)
		pl=$(expr 0 + $t_pl)
		lwp=$(expr 0 + $t_lwp)
		net_days=`expr $totdays - $t_cl - $t_ml - $t_pl - $t_lwp`
		td=$(expr 0 + $net_days)
	fi

	#write record to master file

sqlplus -s hr/123456 << EOF
set feedback off;
update emaster
set
Name_of_Employee='$2',Sex='$3',Address='$4',City='$5',Pincode='$6',Department='$7',Grade='$8',GPF_No=$9,GI_Scheme_No=${10},ESI_Scheme_No=${11},CL_Allowed=${12},PL_Allowed=${13},ML_Allowed=${14},Basic_Salary=${15},E_Cum_Cl=$cl,E_Cum_Pl=$pl,E_Cum_Ml=$ml,E_Cum_Lwp=$lwp,E_Cum_Att=$td
where Employee_Code='$e_empcode';
commit;
EOF

#sqlplus -s hr/123456 << EOF
#set feedback off;
#insert into etran (employee_code, department, casual_leave, medical_leave, prov_leave, leave_w_pay,special_pay_1, special_pay_2, income_tax, rent_ded, long_t_loan, short_t_load, special_ded_1, special_ded_2, T_da, T_hra, t_ca, t_cca, t_gpf, T_esis, T_gis, T_prof_tax, t_gs, total_ded, total_net_pay) values (Name_of_Employee='$2',Sex='$3',Address='$4',City='$5',Pincode='$6',Department='$7',Grade='$8',GPF_No=$9,GI_Scheme_No=${10},ESI_Scheme_No=${11},CL_Allowed=${12},PL_Allowed=${13},ML_Allowed=${14},Basic_Salary=${15},E_Cum_Cl=$cl,E_Cum_Pl=$pl,E_Cum_Ml=$ml,E_Cum_Lwp=$lwp,E_Cum_Att=$td);
#commit;
#EOF
	echo $1:$2:$3:$4:$5:$6:$7:$8:$9:${10}:${11}:${12}:${13}:${14}:${15}:$cl:$pl:$ml:$lwp:$td | dd conv=ucase 2>/dev/null>>/tmp/master.aaa

	mv /tmp/master.aaa $MASTER
	exec < $t
	writerc "Add another y/n: " 23 10 "N"
	read another

clear
done



