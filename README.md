## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

| English | [Español](README%20ESPAÑOL.md) |
| --- | --- |

❗ Using this tool in controlled environments is completely illegal without the necessary authorization.

## How is the tool executed?

```
git clone https://github.com/Kidd3n/WifiPwnedd.git

cd WifiPwnedd

chmod 755 wifipwnedd.sh

sudo ./wifipwnedd.sh
```

## Attack menu 

![Screenshot_2023-11-14_17-53-37](https://github.com/Kidd3n/WifiPwnedd/assets/89719224/f7a102ba-4dcf-4f83-ba9d-d854881428bf)









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

- The packet rate is 1000 packets per second, but it depends on your network card the speed. 

### 5) Network Traffic

- You can monitor all traffic and parcels that travel 

### 6)  Scanner

- will reboot the entire network card to be able to reconnect to a network. 

- It will then search for the devices on our network and display them on the screen with their IP addresses. 

- After hitting enter it will put our card in monitor mode

### 7)  DoS for Client 

- This module is used to remove internet access to a client in our network using ARP packets with arpspoof.

- We must be on a private network before entering this module.

- We will be asked for an ip address, we must enter the one of our victim.

- Then we will set in seconds the time we want to take away the access

- Credits: The creator of this script was @PinguinodeMario, Thank you for allowing it to be in this tool.

- Script Video: https://youtu.be/MbB0XRjFS_Y?si=1i1ajq_NEBHYmH-8 (Spanish)

### 8) Wifiphisher/Evil Twin

- You must choose a network to which global deauthentication packets will be sent (All MAC'S), this so that users do not have the network available and connect to our network.

- The network name is the same as the network we want to clone.

- It will generate the hostapd and dnsmasq configuration files, and will also configure that when a device connects it will be assigned an IP address and a NetMask.

- Then we can choose a login to use

- We wait for the credentials of the victims

### 9) Fake/Rogue Ap

- Create a fake network with the name of your choice.

- It will generate the hostapd and dnsmasq configuration files with the name and channel we gave earlier, and also configure that when a device is connected it is assigned an IP address and a NetMask.

- Then we can choose a login to use

- We wait for the credentials of the victims

### 10) Force Brute .cap

- Brute-force the dictionary we pass to a .cap file.

### 11) Hash .cap -> .hccapx

- Convert your hash or .cap file to hccapx

### 12) Hashed Dictionary (Rainbow Tables)

- It is a precomputed dictionary used for brute-forcing hashes. This will help speed up the process (depending on the passwords)

### 13) Force brute with GPU

- ❕ This option cannot be done in a virtual machine, it will only work when the OS is directly installed. 

- It will ask for a hash, either .cap or hccapx, if it is .cap it will be automatically converted to hccapx format with the name you want.

- Then a menu will pop up where we will see our Hardware and we can select our GPU (If you put a CPU, the brute force will not be done).

- It will automatically brute force the process with our preferred dictionary to the hash and with the GPU of your pc.
