#!/usr/bin/bash

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

function removeRepeatedLines(){
	cat hashes.tmp | awk '!a[$0]++'> cleanRepeated.tmp; cat cleanRepeated.tmp>hashes.tmp; rm cleanRepeated.tmp

}

function encrypter(){
	phraseToSave=$1
	encryptedPhrase=`echo -n "$phraseToSave" | sha256sum | cut -d" " -f1`
	toSave=$phraseToSave:$encryptedPhrase
	echo $toSave >> hashes.tmp

	# Delete empty lines
	sed -i '/^[[:space:]]*$/d' hashes.tmp

	echo -ne "\n${purpleColour}The hash is: ${endColour}$word$encryptedPhrase\n"

	removeRepeatedLines

	echo -ne "\n${greenColour}Password was encrypted well! ${endColour}$word\n"
	
	tput cnorm;
}

function decrypterByHash(){
	hashToDecrypt=$1
	lineOfHash=`cat hashes.tmp | grep -nw "$hashToDecrypt"| cut -d":" -f1`

	if [ -n "$(echo $lineOfHash)" ]; then
		word=`sed -n "$lineOfHash"p hashes.tmp | cut -d":" -f1`
		echo -ne "\n${greenColour}The word is: ${endColour}$word\n"
	else
		echo -ne "\n${redColour}No matches";for i in $(seq 1 3); do sleep 0.3;echo -ne "${redColour}.${endColour}";done
	fi
	
	tput cnorm;
}

function helpPanel(){
	echo -e "\n${redColour}[!] Uso: ./Cipher${endColour}"
	for i in $(seq 1 80); do echo -ne "${redColour}-"; done; echo -ne "${endColour}"
	echo -e "\n\n\t${grayColour}[-e]${endColour}${yellowColour} Encriptar frase${endColour}"
	echo -e "\n\t${grayColour}[-d]${endColour}${yellowColour} Desencriptar hash${endColour}"
	echo -e "\n\t${grayColour}[-h]${endColour}${yellowColour} Mostrar este panel de ayuda${endColour}\n"

	tput cnorm; exit 1
}

## __MAIN__ ##

	clear
	parameter_counter=0

	while getopts "e:d:h:" opt
	do
		case $opt in
			e ) TEXT_TO_ENCRYPT=$OPTARG;CHOOSED=$opt; let parameter_counter+=1 ;;
			d ) TEXT_TO_DECRYPT=$OPTARG;CHOOSED=$opt; let parameter_counter+=1 ;;
			h ) helpPanel ;;
		esac
	done

	# Ocultar el ratón
	tput civis

	if [ $parameter_counter -eq 0 ]; then
		helpPanel
	else
		DASH="\-"
		contatenateOpt=$DASH$CHOOSED
		if [ "$(echo $contatenateOpt)" == "\-e" ]; then
			encrypter $TEXT_TO_ENCRYPT
		elif [ "$(echo $contatenateOpt)" == "\-d" ]; then
			decrypterByHash $TEXT_TO_DECRYPT
		else
			helpPanel
		fi
	fi
