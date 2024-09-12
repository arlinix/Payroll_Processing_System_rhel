# for modify the record of transaction file..

oldIFS="$IFS"
another=y
t=`tty`

while [ "$another" = y -o "$another" = Y ]
do
	clear
	writecenter "Payroll Processing System" 1 "B"
	writecenter "Modify Records - Transaction File " 2 "B"

	writerc "Employee code: " 4 10 "B"
	read t_empcode
	if [ -z "$t_empcode" ]
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
echo $tline > /tmp/t_modi
	grep ^$t_empcode: $TRAN > /dev/null
        if [ $? -ne 0 ]
        then
        	if [ ! "$1" == "$t_empcode" ]
        	then
		writerc "Employee code does not exist. Press any key..." 10 10 "B"
		read key
		continue
		fi
	fi


	writerc "Dept:$2 " 5 10 "N"
	read t_dept

	if [ -z "$t_dept" ]
	then
		t_dept=$2
	fi

	writerc "Casual leave:$3 " 6 10 "N"
	read t_cl
	if [ -z $t_cl ]
	then
		t_cl=$3
	fi

	writerc "Medical leave:$4 " 7 10 "N"
	read t_ml
	if [ -z $t_ml ]
	then
		t_ml=$4
	fi

	writerc "Provisional leave:$5 " 8 10 "N"
	read t_pl
	if [ -z $t_pl ]
	then
		t_pl=$5
	fi

	writerc "LWP:$6 " 9 10 "N"
	read t_lwp
	if [ -z $t_lwp ]
	then
		t_lwp=$6
	fi

	writerc "Special Pay 1:$7 " 10 10 "N"
	read t_sppay_1
	if [ -z $t_sppay_1 ]
	then
		t_sppay_1=$7
	fi

	writerc "Special Pay 2:$8 " 11 10 "N"
	read t_sppay_2
	if [ -z $t_sppay_2 ]
	then
		t_sppay_2=$8
	fi

	writerc "Income Tax:$9 " 12 10 "N"
	read t_inc_tax
	if [ -z $t_inc_tax ]
	then
		t_inc_tax=$9
	fi


	writerc "Rent deduction:${10} " 13 10 "N"
	read t_rent_ded
	if [ -z $t_rent_ded ]
	then
		t_rent_ded=${10}
	fi

	writerc "Long term loan:${11} " 14 10 "N"
	read t_lt_loan
	if [ -z $t_lt_loan ]
	then
		t_lt_loan=${11}
	fi

	writerc "Short term loan:${12} " 15 10 "N"
	read t_st_loan
	if [ -z $t_st_loan ]
	then
		t_st_loan=${12}
	fi

	writerc "Special ded 1:${13} " 16 10 "N"
	read t_spded_1
	if [ -z $t_spded_1 ]
	then
		t_spded_1=${13}
	fi

	writerc "Special ded 2:${14}  " 17 10 "N"
	read t_spded_2
	if [ -z $t_spded_2 ]
	then
		t_spded_2=${14}
	fi

	t_da=${15}
        t_hra=${16}
        t_ca=${17}
        t_cca=${18}
	t_gpf=${19}
        t_esis=${20}
        t_gis=${21}
	t_prof_tax=${22}

	mline=$(sqlplus -S hr/123456 << EOF
        set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
        select * from emaster where employee_code='$t_empcode';
EOF
)
        set -- $mline
	
	bs=`echo $mline | cut -d " " -f15`

	t_gs=$(echo "$bs+$t_da+$t_hra+$t_ca+$t_cca+$t_sppay_1+$t_sppay_2"|bc)

	t_tot_ded=$(echo "$t_gpf+$t_esis+$t_gis+$t_prof_tax+$t_inc_tax+$t_lt_loan+$t_st_loan+$t_rent_ded+$t_spded_1+$t_spded_2"|bc)

	t_net_pay=$(echo "$t_gs-$t_tot_ded"|bc)
	e_cum_cl=0
	e_cum_pl=0
	e_cum_ml=0
	e_cum_lwp=0
	e_cum_att=0
	IFS="$oldIFS"


sqlplus -S hr/123456 << EOF
set feedback off;
update etran
set
Department = '$t_dept',Casual_Leave = $t_cl,Medical_Leave = $t_ml,Prov_Leave = $t_pl,Leave_W_Pay = $t_lwp,Special_Pay_1 = $t_sppay_1,Special_Pay_2 = $t_sppay_2,Income_Tax = $t_inc_tax,Rent_Ded = $t_rent_ded,Long_T_Loan = $t_lt_loan,Short_T_Loan = $t_st_loan,Special_Ded_1 = $t_spded_1,Special_Ded_2 = $t_spded_2,T_Da = $t_da,T_Hra = $t_hra,T_Ca = $t_ca,T_Cca = $t_cca,T_Gpf = $t_gpf,T_Esis = $t_esis,T_Gis = $t_gis,T_Prof_Tax = $t_prof_tax,T_Gs = $t_gs,Total_Ded = $t_tot_ded,Total_Net_Pay = $t_net_pay
where Employee_Code = '$t_empcode';
commit;
EOF

	echo $t_empcode:$t_dept:$t_cl:$t_ml:$t_pl:$t_lwp:$t_da:$t_hra:$t_ca:$t_cca:$t_sppay_1:$t_sppay_2:$t_gs:$t_gpf:$t_gis:$t_esis:$t_inc_tax:$t_prof_tax:$t_rent_ded:$t_lt_loan:$t_st_loan:$t_spded_1:$t_spded_2:$t_tot_ded:$t_net_pay | dd conv=ucase >> /tmp/etran.mmm 2> /dev/null
	
	mv /tmp/etran.mmm $TRAN
	days="31 28 31 30 31 30 31 31 30 31 30 31"
	month=`date +%m`
	totdays=`echo $days | cut -d" " -f$month`

	IFS=":"
        exec < $MASTER

	while read e_empcode e_empname e_sex e_address e_city e_pin e_dept e_grade e_gpf_no e_gis_no e_esis_no e_max_cl e_max_pl e_max_ml e_bs e_cum_cl e_cum_pl e_cum_ml e_cum_lwp e_cum_att
	do
		IFS="$oldIFS"
		if [ $e_empcode = $t_empcode ]
		then
			e_cum_cl=` expr 0 + $t_cl`
			e_cum_ml=` expr 0 + $t_ml`
			e_cum_pl=` expr 0 + $t_pl`
			e_cum_lwp=` expr 0 + $t_lwp`
			net_days=` expr $totdays - $t_cl - $t_ml - $t_pl - $t_lwp`
        		e_cum_att=` expr 0 + $net_days`
		fi

	echo $e_empcode:$e_empname:$e_sex:$e_address:$e_city:$e_pin:$e_dept:$e_grade:$e_gpf_no:$e_gis_no:$e_esis_no:$e_max_cl:$e_max_pl:$e_max_ml:$e_bs:$e_cum_cl:$e_cum_pl:$e_cum_ml:$e_cum_lwp:$e_cum_att | dd conv=ucase >> /tmp/master.aaa 2> /dev/null

sqlplus -S hr/123456 << EOF
set feedback off;
update emaster
set
Name_of_Employee = '$e_empname',Sex = '$e_sex',Address = '$e_address',City = '$e_city',Pincode = $e_pin,Department = '$e_dept',Grade = '$e_grade',GPF_No = $e_gpf_no,GI_Scheme_No = $e_gis_no,ESI_Scheme_No = $e_esis_no,CL_Allowed = $e_max_cl,PL_Allowed = $e_max_pl,ML_Allowed = $e_max_ml,Basic_Salary = $e_bs,E_Cum_Cl = $e_cum_cl,E_Cum_Pl = $e_cum_pl,E_Cum_Ml = $e_cum_ml,E_Cum_Lwp = $e_cum_lwp,E_Cum_Att = $e_cum_att
where Employee_Code = '$e_empcode';
commit;
EOF
	IFS=":"
	done
	mv /tmp/master.aaa $MASTER
	exec < $t
	IFS="$IFSspace"

	writerc "Modify another y/n: " 20 20 "N"
	read another
done



