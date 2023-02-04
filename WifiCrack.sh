#!/bin/bash

purpleColour="\e[0;35m\033[1m"
endColour="\033[0m\e[0m"
grayColour="\e[0;37m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
cleancolor="echo -e "${endColour}""
blueColour="\e[0;34m\033[1m"
redColour="\e[0;31m\033[1m"


echo -e "${turquoiseColour}"
echo " ( ( ( /\ ) ) )  "
echo "      /\/\      "  
echo "     /\/\/\       " 
echo "    /)/\/\(\   "
echo "   /\/\/\/\/\ "
echo "  / O O O O  \ "
echo "WifiCrack ByKidd3n"
echo "/\/\/\/\/\/\/\/\ "

echo -e "${purpleColour}"
read -p "[+] Enter para continuar"
	$cleancolor
	iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
	echo -e "${blueColour}"
	read -p "[?] Que tarjeta deseas usar: " tar
	$cleancolor
	echo -e "\n[*] Se esta iniciando el modo monitor en $tar\n"
	airmon-ng start $tar > /dev/null 2>&1
	airmon-ng check kill > /dev/null 2>&1
	echo -e "${redColour}"
	echo -e "\n[*] Ya tienes tu tarjeta preparada!\n"
