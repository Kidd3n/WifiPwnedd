## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)
![Wifi-Crack-critical](https://user-images.githubusercontent.com/89719224/216780347-516cd39c-132b-4082-b1e1-174aec9ec5a8.svg)
![Aircrack---ng-lightgrey](https://user-images.githubusercontent.com/89719224/216780435-f0d943b3-9f94-4ae8-aee0-409dd954aea5.svg)

Herramienta para automatizar ataques WiFi (WPA/WPA2 - PSK - Hijacking)

❗ Usar esta herramienta en entornos controlados, es totalmente ilegal hacerlo sin tener la autorizacion necesaria.

## Como se ejecuta la herramienta? 

```
cd WifiPwnedd

chmod 755 WifiPwnedd.sh

sudo ./WifiPwnedd.sh
```

## Menu de ataques 

- Configura la tarjeta que tu le indiques para que este en modo monitor (necesario)

- Se cambia la direccion MAC con Macchanger para ser aun mas anonimos 

### 1) Ataque Handshake 

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

### 2) Ataque PMKID 

- Esperara el paquete necesario por 60 segundos

- Si lo captura pasara a la fase de fuerza bruta con hashcat

- Si no lo captura se cerrara el programa

### 3) Menu Fuerza Bruta

- Tendremos varia opciones la primera es para atacar un archivo .cap 

- El segundo lo que podemos hacer es un diccionario precomputado, esto hara que sea mas rapido el proceso de fuerza bruta

### 4) Ataque evilTrust

- Despliegue automatizado de un Rogue AP con capacidad de selección de plantilla + 2FA.

- Si quieres apoyar al creador y ver mas sobre la herramienta: https://github.com/s4vitar/evilTrust

- Le estare haciendo modificaciones al codigo, ya que esta desactualizado pero el creador seguira siendo S4vitar

### 5) Scanner

- Nos buscara los dispotivos de nuestra red y se nos mostrara por pantalla con la ip
