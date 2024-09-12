Prerequisite:
Oracle 11G/12C
Linux: RHEL 8

Step 1: Make a directory bin in your home directory.
Step 2: Add /home/user/bin in your path environment variable.
step 3: Copy all the files in the /home/user/bin and give execute permission to every file.
step 4: simply execute, paymain.sh

paymain.sh    -->  dboper.sh  --> mde.sh   -->   madd.sh (to add employee details)
                                           -->   mmodi.sh (to modify employee details)
                                           -->   mdel.sh (To delete record)
                                           -->   mret.sh (to retrieve the data of employees)
                              --> tde.sh   -->   tadd.sh (to add transaction record of employee)
                                           -->   tde.sh  (To delete transaction record)
                                           -->   tmodi.sh (modify)
                                           -->   tret.sh (to view)
              --> reports.sh               -->   maillbl.sh
                                           -->   lsr.sh
                                           -->   payprint.sh
                                           -->   spreadsheet.sh
              --> sysmnt.sh                -->   clmonth.sh
                                           -->   clyear.sh

General Files:
writecentre
writerc
