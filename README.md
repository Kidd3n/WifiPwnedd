## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

❗ Using this tool in controlled environments is completely illegal without the necessary authorization.

## How is the tool executed?

```
cd WifiPwnedd

chmod 755 wifipwnedd.sh

sudo ./wifipwnedd.sh
```

## Attack menu 
![banner](https://user-images.githubusercontent.com/89719224/227698176-f602ecf2-6d91-40df-92da-31cbe4bd88b5.png)








- Configure the specified card to be in monitor mode (required)

- The MAC address is changed with Macchanger to be even more anonymous 

### 1) Handshake Attack

- An airodump-ng window will appear with all the available networks and their channels. We must correctly indicate the name of the network and its channel.

- Next a similar window will appear, but now filtered by the name (essid) and the channel that we have previously provided

- We wait a few seconds and the deauthentication attack with aireplay-ng will start.

- After a few seconds, we will get the necessary packet with the encrypted password (Handshake).

- It will then perform a brute force attack with the dictionary we provided (it will take a while depending on your computer and the password)

### 2) PMKID Attack

- It will wait for the requested packet with hcxdumptool for the number of seconds you specify (recommended 600).

- If it captures it, it will proceed to the brute force phase with hashcat.

- If it does not capture it, the attack will be closed and we will return to the attack menu.

### 3) DoS Attack

- It will ask us which network we want to attack

- Then it will ask us for the channels, the recommended ones are 1, 6, 11 but you can put all of them from 1 to 12 or whatever you prefer. 

- The network can change channels to avoid this attack.

- You can close the window when you want the attack to end. 

### 4) Beacon Flood Attack

- It will ask us if we want to give a name to the fake network. If we say yes (Y), it will ask us for the name and start sending the network by packets (Recommended).

- (Recommended) If we say no (N), it will flood the network area with strange names.

- The packet rate is 1000 packets per second, but it depends on your network card the speed. 

### 5) Network Traffic

- You can monitor all traffic and parcels that travel 

### 6)  Scanner

- will reboot the entire network card to be able to reconnect to a network. 

- It will then search for the devices on our network and display them on the screen with their IP addresses. 

- After hitting enter it will put our card in monitor mode

### 7) Wifiphisher

- Evil Twin 

- Creates a fake network with the name of your choice 

- It will generate hostapd and dnsmasq configuration files with the name and channel that we gave previously, and also configure that when a device is connected it is assigned an IP address and a NetMask.

- Then we can choose a login to use

- We are waiting for the credentials of the victims

### 8) Fake/Rogue Ap

- Create a fake network with the name and channel of your choice

### 9) Force Brute .cap

- Brute-force the dictionary we pass to a .cap file.

### 10) Hash .cap -> .hccapx

- Convert your hash or .cap file to hccapx

### 11) Hashed Dictionary (Rainbow Taibles)

- It is a precomputed dictionary used for brute-forcing hashes. This will help speed up the process (depending on the passwords)

### 12) Force brute with GPU

- ❕ This option cannot be done in a virtual machine, it will only work when the OS is directly installed. 

- It will ask for a hash, either .cap or hccapx, if it is .cap it will be automatically converted to hccapx format with the name you want.

- Then a menu will pop up where we will see our Hardware and we can select our GPU (If you put a CPU, the brute force will not be done).

- It will automatically brute force the process with our preferred dictionary to the hash and with the GPU of your pc.
