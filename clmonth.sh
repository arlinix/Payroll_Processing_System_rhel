# Closes the monthly transaction file.


clear
writecenter "Payroll Processing System" 2 "B"
writecenter "Close Current Month" 3 "B"

set `date`
cur_mth=$2

if [ -f "etran$cur_mth.dbf" ]
then
	writecenter "Month has already been closed. Press any key..." 15 "B"
	read key
	break
fi

mcount=`wc -l < $MASTER`
tcount=`wc -l < $TRAN`

# if all records have not been entered in transaction file
if [ "$mcount" -gt "$tcount" ]
then
	writecenter "Transaction file incomplete.Cannot close month." 15 "B"
	writecenter "Press any key..." 16 "B"
	read key
	break
fi

# check for success
if mv $TRAN etran$cur_mth.dbf
then 
	touch $TRAN
	writecenter "Month successfully closed...Press any key" 15 "B"
else
	writecenter "Unable to close month...Press any key" 15 "B"
fi
read key
break



