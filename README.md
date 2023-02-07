## WifiCrack
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)
![Wifi-Crack-critical](https://user-images.githubusercontent.com/89719224/216780347-516cd39c-132b-4082-b1e1-174aec9ec5a8.svg)
![Aircrack---ng-lightgrey](https://user-images.githubusercontent.com/89719224/216780435-f0d943b3-9f94-4ae8-aee0-409dd954aea5.svg)


Herramienta para automatizar ataques WiFi (WPA/WPA2 - PSK)

- Configura la tarjeta que tu le indiques para que este en modo monitor (necesario)

- Se cambia la direccion MAC con Macchanger para ser aun mas anonimos 

- Nos saldra una ventana con todas las redes disponibles y sus canales, le debemos indicar el nombre correctamnete de la red y su canal

- Luego nos saldra una ventana igual, solo que ahora estara filtrada por el nombre y el canal que le pasamos anteriormente

- Esperamos unos segundos y empezara el ataque a la red

- Despues de algunos segundos vamos a optener un Handshake

- Nos preguntara por algun diccionario que queramos usar, igual se dara la ruta de rockyou.txt por si quieres usar ese diccionario (El rockyou en kali esta comprimido, para descomprimir el archivo debemos aplicar estos comandos): 
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ cd /usr/share/wordlists
```
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ gunzip -d rockyou.txt.gz
```

- Luego se hara fuerza bruta con el diccionario que le pasamos (Durara bastante dependiendo de tu computadora y de la contraseña)

## Como se ejecuta la herramienta? 

### Clonamos el repositorio
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ git clone https://github.com/Kidd3n/WifiCrack.git
```
### Vamos a la carpeta
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ cd WifiCrack
```
### Le damos permiso de ejecucion a la herramienta
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ chmod 755 WifiCrack.sh
```
### Ejecutamos la herramienta como root
```batch
    ┌──(kidden㉿kidd3n)-[~]
    └─$ sudo ./WifiCrack.sh
```
![image](https://user-images.githubusercontent.com/89719224/216750782-c4c7908d-f428-4263-8e8f-57b61154af76.png)
