# Displays Reports menu and branches control to generate appropriate report

while true
do
	clear
	writerc "\033[1mPayroll Processing System\033[0m" 3 28 "R"
	writerc "\033[1mReports Menu\033[0m" 4 34 "B"
        writerc "\033[1;7mM\033[0m Mailing Labels" 6 30 "N"
        writerc "\033[1;7mL\033[0m Leave Status Report" 7 30 "N"
        writerc "\033[1;7mP\033[0m Paysheet Printing" 8 30 "N"
        writerc "\033[1;7mS\033[0m Summary Payroll Sheet" 9 30 "N"
        writerc "\033[1;7mR\033[0m Return to Main Menu" 10 30 "N"
        writerc "Your Choice: " 12 30 "N"

	choice=""
		stty -icanon min 0 time 0
	while [ -z $choice ]
	do
		read choice
	done
		stty sane

	case $choice in
		[Mm])  maillbl.sh ;;
		[Ll])  lsr.sh ;;
		[Pp])  payprint.sh ;;
		[Ss])  spaysheet.sh ;;
		[Rr]) clear
		      break ;;
	           *) echo -e "\007" ;;
	esac
done
