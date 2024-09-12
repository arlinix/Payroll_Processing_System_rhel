# Does some initial house keeping, Displays Main Menu
# And branches control to appropriate sub menu

MASTER=$PWD/emaster.dbf
TRAN=$PWD/etran.dbf
export MASTER TRAN

CHECK_TABLE_SQL="SELECT count(*) FROM all_tables WHERE owner='HR' AND table_name='EMASTER';"

if  sqlplus -S "hr/123456" <<EOF | grep -wq 0
$CHECK_TABLE_SQL
EOF
then
    sqlplus -S hr/123456 <<EOF
    set feedback off;

    create table emaster(Employee_Code number primary key,Name_of_Employee varchar2(40),Sex varchar2(4),Address varchar2(100),City varchar2(30),Pincode number(10),Department varchar2(20),Grade varchar(3),GPF_No number(10),GI_Scheme_No number(10),ESI_Scheme_No number(10),CL_Allowed number(2),PL_Allowed number(2),ML_Allowed number(2),Basic_Salary number,E_Cum_Cl number(2) default 0,E_Cum_Pl number(2) default 0,E_Cum_Ml number(2) default 0,E_Cum_Lwp number(2) default 0,E_Cum_Att number(2) default 0);

    create table etran(Employee_Code number primary key,Department varchar2(30),Casual_Leave number,Medical_Leave number,Prov_Leave number,Leave_W_Pay number,Special_Pay_1 number,Special_Pay_2 number,Income_Tax number,Rent_Ded number,Long_T_Loan number,Short_T_Loan number,Special_Ded_1 number,Special_Ded_2 number,T_Da number,T_Hra number,T_Ca number,T_Cca number,T_Gpf number,T_Esis number,T_Gis number,T_Prof_Tax number,T_Gs number,Total_Ded number,Total_Net_Pay number, constraint etran_table foreign key(Employee_Code) references emaster(Employee_Code)) ;
EOF

fi

if [ ! -f $MASTER ]
then 
	touch $MASTER
fi
if [ ! -f $TRAN ]
then
	touch $TRAN
fi

while true
do
	clear
	writerc "\033[1mPayroll Processing System\033[0m" 3 28 "R"
	writerc "\033[1mMain Menu\033[0m" 4 35 "B"
	writerc "\033[1;7mD\033[0m Database Operations" 6 30 "N"
	writerc "\033[1;7mR\033[0m Reports" 7 30 "N"
	writerc "\033[1;7mS\033[0m System Maintenance" 8 30 "N"
	writerc "\033[1;7mE\033[0m Exit" 9 30 "N"
	writerc "Your Choice: " 11 30 "N"

	choice=""
	stty -icanon min 0 time 0
	while [ -z $choice ]
	do
	 	 read choice
	done
	stty sane

	case $choice in
		[Dd])  dboper.sh ;;
		[Rr])  reports.sh ;;
		[Ss])  sysmnt.sh ;;
		[Ee])   break ;;
		   *) echo -e "\007" ;;
        esac
done
