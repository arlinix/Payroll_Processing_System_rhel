# Prints mailing labels.

clear
t=`tty`

writerc "Screen/Printer " 10 20 "B"
read ans
writerc "Please wait...Mail Label Created" 12 22 "B"
sleep 2

exec < $MASTER

while true
do
	read line1

     	# if record read successfully
	if [ $? -eq 0 ]
	then

        # seperate out relevant fields
	name1=$(echo "$line1" | cut -d ":" -f2)
	add1=$(echo "$line1" | cut -d ":" -f4)
	city1=$(echo "$line1" | cut -d ":" -f5)
	pin1=$(echo "$line1" | cut -d ":" -f6)

	# calculate lengths of various fields
	ln1=$(echo "$name1" | wc -c)
	la1=$(echo "$add1" | wc -c)
	lc1=$(echo "$city1" | wc -c)
	lp1=$(echo "$pin1" | wc -c)

	# calculate blanks to be padded
	bn1=$(expr 40 - $ln1)
	ba1=$(expr 40 - $la1)
	bc1=$(expr 40 - $lc1)
	bp1=$(expr 40 - $lp1)

	# pad blanks after name 
	count=1
	while [ $count -le $bn1 ]
	do
		name1="$name1"
		count=$(expr $count + 1)
	done

	# pad blanks after address
	count=1
	while [ $count -le $ba1 ]
	do
		add1="$add1"
		count=$(expr $count + 1)
	done

	# pad blanks after city
	count=1
	while [ $count -le $bc1 ]
	do
		city1="$city1"
		count=$(expr $count + 1)
	done

	# pad blanks after pin
	count=1
	while [ $count -le $bp1 ]
	do
		pin1="$pin1"
		count=$(expr $count + 1)
	done
	else
		break
	fi

	# read another record from file
	line2=""
	read line2

	# seperate out relevant fields
	name2=$(echo "$line2" | cut -d ":" -f2)
	add2=$(echo "$line2" | cut -d ":" -f4)
	city2=$(echo "$line2" | cut -d ":" -f5)
	pin2=$(echo "$line2" | cut -d ":" -f6)

	# write fields from 2 records side by side
	echo "$name1      $name2" >> mail.lbl
	echo "$add1     $add2" >> mail.lbl
	echo "$city1    $city2" >> mail.lbl
	echo "$pin1     $pin2" >> mail.lbl
	echo  >> mail.lbl

done
exec < $t
