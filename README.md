## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

❗ Using this tool in controlled environments is completely illegal without the necessary authorization.

## How is the tool executed?

```
cd WifiPwnedd

chmod 755 WifiPwnedd.sh

sudo ./WifiPwnedd.sh
```

## Attack menu 
![cap](https://user-images.githubusercontent.com/89719224/223302253-207bc04b-de4b-4098-bc6b-e2ea729342ed.png)



- Configure the specified card to be in monitor mode (required)

- The MAC address is changed with Macchanger to be even more anonymous 

### 1) Handshake Attack

- A window will appear with all available networks and their channels. We must correctly indicate the name of the network and its channel.

- Then a similar window will appear, but now it will be filtered by the name and channel we provided earlier

- We wait a few seconds and the attack on the network will begin

- After a few seconds, we will obtain a Handshake

- It will ask us if we want to use any dictionary, and it will also give the path to rockyou.txt in case we want to use that dictionary. (The rockyou dictionary in Kali is compressed, so we need to apply these commands to decompress the file): 
```
cd /usr/share/wordlists

gunzip -d rockyou.txt.gz
```

- Then it will perform a brute-force attack with the dictionary we provided (it will take a while depending on your computer and the password)

### 2) PMKID Attack

- It will wait for the required packet for the number of seconds we specify

- If it captures it, it will move on to the brute-force phase with hashcat

- If it does not capture it, the attack will be closed

### 3) DoS Attack

- It will ask us which network we want to attack

- Then it will ask for the channels, the recommended ones are 1, 6, 11 but you can put all from 1-12 or the ones you prefer 

- The network may change channels

### 4) Beacon Flood Attack

- It will ask us if we want to name the network. If we say yes (Y), it will ask for the name and start the attack

- (Recommended) If we say no (N), we will flood the area with networks with strange names.

### 5) Scanner

- It will search for the devices on our network and show them on the screen with their IP addresses.

### 6)  Evil Trust

- Automated deployment of a Rogue AP with template selection capability + 2FA

- If you want to support the creator and learn more about the tool: https://github.com/s4vitar/evilTrust

- I will be making modifications to the code, as it is outdated, but the creator will still be S4vitar

### 7) Force Brute .cap

- It will perform a brute-force attack on a .cap Handshake

### 8) Rainbow Taibles

- It is a precomputed dictionary used for brute-forcing hashes. This will help speed up the process (depending on the passwords)
