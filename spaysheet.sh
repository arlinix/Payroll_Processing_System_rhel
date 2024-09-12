# spaysheet.sh
# Prints department-wise summary payroll sheet.

clear

#possible departments in the company
dept="MFG:ASSLY:STORES:MAINT:ACCTS"

t=`tty`
IFSspace="$IFS"
IFScolon=":"

month=`date +%B`
year=`date +%Y`

#display report titles
writerc "\033[1mPayroll Processing System\033[0m" 1 27 "B"
writecenter "Summary Payroll Sheet" 2 "B"
writecenter "$month $year" 3 "B"

#display column headings
writerc "Total" 5 20 "B"
writerc "Gross" 5 35 "B"
writerc "Gross" 5 50 "B"
writerc "Net" 5 70 "B"
writerc "Department" 6 5 "B"
writerc "Employees" 6 20 "B"
writerc "Earning" 6 35 "B"
writerc "Deduction" 6 50 "B"
writerc "Payments" 6 70 "B"

count=1
row=8

#run the loop for 5 different departments in the company
while [ $count -le 5 ]
do
        #pickup one department
        var=`echo $dept|cut -d ":" -f$count`
        tot_emp=0
        gross_earn=0
        gross_ded=0
        net_pay=0
        IFS="$IFScolon"

        # set standared input to transaction file
        exec < $TRAN

        # read records from transaction file
        while read t_empcode t_dept t_cl t_ml t_pl t_lwp t_da t_hra t_ca t_cca t_sppay_1 t_sppay_2 t_gs t_gpf t_gis t_esis t_inc_tax t_prof_tax t_rent_ded t_lt_loan t_st_loan t_spded_1 t_spded_2 t_tot_ded t_net_pay
        do
        IFS="$IFSspace"

        #if department matches
        if [ "$t_dept" == "$var" ]
        then
                tot_emp=$(echo "$tot_emp + 1" |bc)
                gross_earn=$(echo "$gross_earn + $t_gs" |bc)
                gross_ded=$(echo "$gross_ded + $t_tot_ded" |bc)
                net_pay=$(echo "$net_pay + $t_net_pay" |bc)
        fi

                IFS="$IFScolon"
        done

        #reset standared input to terminal
        exec < $t


        # output summary values of one department
        writerc "$var" $row 5 "N"
        writerc "$tot_emp" $row 20 "N"
        writerc "$gross_earn" $row 35 "N"
        writerc "$gross_ded" $row 50 "N"
        writerc "$net_pay" $row 70 "N"
        IFS="$IFSspace"
        row=`expr $row + 1`
        count=`expr $count + 1`
done

IFS="$IFSspace"

writerc "Press any key..." 24 10 "N"
read key

