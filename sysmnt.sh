# Displays System Maintenance Menu and branches control to 
# carry out appropriate house-keeping job

while true
do
	clear
	writerc "\033[1mPayroll Processing System\033[0m" 3 28 "R"
	writerc "\033[1mSystem Maintenance Menu\033[0m" 4 29 "B"
        writerc "\033[1;7mC\033[0m Close Month" 6 29 "N"
        writerc "\033[1;7mR\033[0m Reorganise & Close Year" 7 29 "N"
        writerc "\033[1;7mP\033[0m Previous Menu" 8 29 "N"
        writerc "Your Choice: " 10 30 "N"

	choice=""
	stty -icanon min 0 time 0
	while [ -z $choice ]
	do
		read choice
	done
	stty sane

	case $choice in
		[cC])  clmonth.sh ;;
		[Rr])  clyear.sh ;;
		[pP]) clear
		      break ;;
	           *) echo -e "\007" ;;
	esac
done
