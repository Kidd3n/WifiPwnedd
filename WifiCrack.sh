#!/bin/bash

# Modulo de colores 
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
cleancolor="echo -e "${endColour}""


if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!] Debes ser root para ejecutar la herramienta -> (sudo $0)"
exit 1
fi

test -f /usr/bin/aircrack-ng
airtest=$(echo $?)

if [ $airtest -eq 0 ]; then
	clear
	# Banner
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
	echo "[+] Github: https://github.com/kidd3n"
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
			echo -e "\n[*] Ya tienes tu tarjeta preparada!"
		$cleancolor
		read -p "${blueColour}Quieres continuar? [Y/N]: " rps
			if rps == "Y" or rps == "y"; then
				$cleancolor
				read -p "Nombre de la red wifi: " wifi
				sudo airodump-ng --essid $wifi ${tar}mon
			fi
			if rps == "N" or rps == "n"; then
				break
			fi
else
	tool_name="aircrack-ng"

	if ! command -v $tool_name > /dev/null 2>&1; then
	  echo -e "\n[*] Instalando aircrack"
	  sudo apt-get install aircrack-ng -y > /dev/null 2>&1 || {
	    echo "[*] Instalando aircrack"
	    sudo pacman -S $tool_name || {
	      echo -e "\n$redColour[!] No se pudo instalar aircrack" >&2
	      exit 1
	    }
	  }
	fi
fi