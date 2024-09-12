MASTER=$HOME/emaster.dbf
TRAN=$HOME/etran.dbf
export MASTER TRAN  
test=`sqlplus -S hr/123456 <<eof
select * from tab where tname='EMASTER';
eof
`
if [ "`echo $test`" == "`cat t_file`" ]
then
#echo "AYA IF M"
sqlplus -S hr/123456 <<eof
set feedback off;

    create table emaster(Employee_Code number primary key,Name_of_Employee varchar2(40),Sex varchar2(4),Address varchar2(100),City varchar2(30),Pincode number(10),Department varchar2(20),Grade varchar(3),GPF_No number(10),GI_Scheme_No number(10),ESI_Scheme_No number(10),CL_Allowed number(2),PL_Allowed number(2),ML_Allowed number(2),Basic_Salary number,E_Cum_Cl number(2) default 0,E_Cum_Pl number(2) default 0,E_Cum_Ml number(2) default 0,E_Cum_Lwp number(2) default 0,E_Cum_Att number(2) default 0);
eof
fi

test=`sqlplus -S hr/123456 <<eof
select * from tab where tname='ETRAN';
eof
`
if [ "`echo $test`" == "`cat t_file`" ]
then
#echo "AYA IF M"
sqlplus -S hr/123456 <<eof
set feedback off;


    create table etran(Employee_Code number primary key,Department varchar2(30),Casual_Leave number,Medical_Leave number,Prov_Leave number,Leave_W_Pay number,Special_Pay_1 number,Special_Pay_2 number,Income_Tax number,Rent_Ded number,Long_T_Loan number,Short_T_Loan number,Special_Ded_1 number,Special_Ded_2 number,T_Da number,T_Hra number,T_Ca number,T_Cca number,T_Gpf number,T_Esis number,T_Gis number,T_Prof_Tax number,T_Gs number,Total_Ded number,Total_Net_Pay number, constraint etran_table foreign key(Employee_Code) references emaster(Employee_Code)) ;
eof
fi



while true
do
clear
 
sh writecentre "\033[31m Payroll Processing system\033[0m" 7 "B" 
sh writecentre "\033[36mMain Menu\033[0m" 8 "N"
sh writerc "\033[1mD\033[0m\033[33matabase operations" 10 30 "N"
sh writerc "\033[1mR\033[0m\033[34meports" 11 30 "N"
sh writerc "\033[1mS\033[0m\033[35mystem maintenance" 12 30 "N"
sh writerc "\033[1mE\033[0m\033[36mxit" 13 30 "N"
sh writerc "Your Choice: " 15 30 "N"

choice=""
stty -icanon min 0  time 0
while [ -z "$choice" ]
do
read choice
done
stty sane

case "$choice" in
[Dd])sh dboper.prg;;
[Rr])sh reports.prg;;
[Ss])sh sysmnt.prg;;
[Ee]) clear
exit;;
*) echo -e "\007";;
esac
done
