# Deletes an existing record from master file


another=y
while [ "$another" = y ]
do
        clear
        writecenter "Payroll Processing System" 1 "B"
        writecenter "Delete Records - Master File" 2 "B"

        writerc "Employee Code to Delete: \c" 6 10 "B"
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

       # check whether employee code exits

        if [ -z "$1" ]
        then
                writerc "Employee code does not exist...Press any key" 10 10 "B"
                read key
                break
        fi


        # rewrite all other records into a new file
        grep -vi ^"$empcode": "$MASTER" > /tmp/emaster.ddd
        mv /tmp/emaster.ddd "$MASTER"

        # check whether there is a corresponding employee in transaction file
        grep -i ^"$empcode": "$TRAN" > /dev/null
        if [ $? -eq 0 ]
        then
                # eliminate the corresponding record from transaction file too
                grep -vi ^"$empcode": "$TRAN" > /tmp/etran.ddd
                mv /tmp/etran.ddd "$TRAN"
        fi

sqlplus -S hr/123456 << EOF > /dev/null
set heading off;
delete etran where employee_code=$empcode;
delete emaster where employee_code=$empcode;
commit;
EOF

        writerc "Delete another y/n: " 16 15 "B"
        read another
        done
