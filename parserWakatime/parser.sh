#!/bin/bash

## @Author: Diego Ferreiro (kr4dd) ##

#Colours
greenColour="\e[0;32m\033[1m" #OK
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m" #FAIL
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m" #WARNING
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -ne "\n${redColour}[!] Exiting"${endColour}; for i in $(seq 1 3); do sleep 0.3;echo -ne "${redColour}.${endColour}";done

	tput cnorm; exit 1
}

clear
FILE="$1"
if [[ $# != 1 || ! -f "$FILE" ]]; then
	echo -ne "HELP MENU: \n"
	echo -ne "=====================\n"	
	echo -ne "Usage example: \n"
	echo -ne "./parser wakatime.json\n"
else

function parseColPretty(){
	col=$($1 | sort | uniq | sed -e 's/^"//;s/"$//')
	for i in ${col[*]}; do echo -ne $i", "; done
}

function getEmail(){
	jq '.user.email' $FILE | sed -e 's/^"//;s/"$//'
}

function totalCodeTime(){
	jq '.days' $FILE | grep -i total_seconds | tr -d " " | cut -d":" -f2 | sed -e 's/\,//g' | grep -vE '^0$' > total_time.txt

	time_used=$(python3 getTotalTime.py)	
	rm total_time.txt
	echo $time_used
}

function getProgrammingLanguages(){
	languages=$(jq '.days | .[] .languages | .[] .name' $FILE | sort | uniq | sed -e 's/^"//;s/"$//;s/"$//;s/ //g')
	cont=0
	for i in ${languages[*]}; do echo -ne $i", "; done | sed 's/, $//'; echo "."
}

function getOS(){
	op_sys=$(jq '.days | .[] .operating_systems| .[] .name' $FILE | sort | uniq | sed -e 's/^"//;s/"$//')
	for i in ${op_sys[*]}; do echo -ne $i", "; done | sed 's/, $//'; echo "."
}

######
#MAIN#
######

echo -e "${greenColour}Hello:${endColour} `getEmail` "
echo -ne "\n==============================================================================\n"
echo -e "${greenColour}[*]You spent${endColour} `totalCodeTime` ${greenColour}making stuff...${endColour}"
echo -ne "\n==============================================================================\n"
echo -e "${greenColour}[*]You use this programming languages:${endColour}\n`getProgrammingLanguages`"
echo -ne "\n==============================================================================\n"
echo -e "${greenColour}[*]Operating systems used:${endColour}\n`getOS`"

fi
