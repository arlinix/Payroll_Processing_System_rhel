# Displays Master Data Entry menu and branches control to 
# carry out appropriate operation on employee master file

while true
do
	clear
	writerc "\033[1mPayroll Processing System\033[0m" 3 28 "R"
	writerc "\033[1mMaster File Data Entry\033[0m" 4 30 "B"
        writerc "\033[1;7mA\033[0m Add Records" 6 31 "N"
        writerc "\033[1;7mM\033[0m Modify Records" 7 31 "N"
        writerc "\033[1;7mD\033[0m Delete Record" 8 31 "N"
        writerc "\033[1;7mR\033[0m Retrirve Record" 9 31 "N"
        writerc "\033[1;7mP\033[0m Previous Menu" 10 31 "N"
        writerc "Your Choice: " 12 31 "N"

	choice=""
	stty -icanon min 0 time 0
	while [ -z $choice ]
	do
		read choice
	done
	stty sane

	case $choice in
		[Aa])  madd.sh ;;
		[Mm])  mmodi.sh ;;
		[Dd])  mdel.sh ;;
		[Rr])  mret.sh ;;
		[Pp]) break;;
	           *) echo -e "\007" ;;
	esac
done
