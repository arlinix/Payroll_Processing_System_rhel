# Displays Database operations menu and branches control to
# either Master or Transaction Data Entry Menu

while true
do
	clear
	writerc "\033[1mPayroll Processing System\033[0m" 3 28 "R"
	writerc "\033[1mData Base Operation\033[0m" 4 31 "B"
        writerc "\033[1;7mM\033[0m Master File Data Entry" 7 29 "N"
        writerc "\033[1;7mT\033[0m Transaction Data Entry" 8 29 "N"
        writerc "\033[1;7mR\033[0m Return to Main Menu" 9 29 "N"
        writerc "Your Choice: " 12 29 "N"

	choice=""
	stty -icanon min 0 time 0
	while [ -z $choice ]
	do
		read choice
	done
	stty sane

	case $choice in
		[Mm])  mde.sh ;;
		[Tt])  tde.sh ;;
		[Rr]) clear
		      break ;;
	           *) echo -e "\007" ;;
	esac
done
