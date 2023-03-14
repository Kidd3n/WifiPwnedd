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
![wifipwneddparrot](https://user-images.githubusercontent.com/89719224/224881946-19479540-8da7-49c9-8baa-7eabb101675d.png)






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

### 5) Scanner

- will reboot the entire network card to be able to reconnect to a network.

- It will then search for the devices on our network and display them on the screen with their IP addresses.

- After hitting enter it will put our card in monitor mode

### 6)  NTWK phishing 

- Network phishing

- Creates a fake network with the name of your choice

- It will generate hostapd and dnsmasq configuration files with the name and channel that we gave previously, and also configure that when a device is connected it is assigned an IP address and a NetMask.

- Then we can choose a login to use

- We are waiting for the credentials of the victims

### 7) Force Brute .cap

- It will perform a brute-force attack on a .cap Handshake

### 8) Rainbow Taibles

- It is a precomputed dictionary used for brute-forcing hashes. This will help speed up the process (depending on the passwords)
