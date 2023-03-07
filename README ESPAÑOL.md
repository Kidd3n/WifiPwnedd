## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

❗ Usar esta herramienta en entornos controlados, es totalmente ilegal hacerlo sin tener la autorizacion necesaria.

## Como se ejecuta la herramienta? 

```
cd WifiPwnedd

chmod 755 WifiPwnedd.sh

sudo ./WifiPwnedd.sh
```

## Menu de ataques 
![wifi2](https://user-images.githubusercontent.com/89719224/222926139-8b7865ce-1b11-46be-a409-3b76dfc81a8d.png)


- Configura la tarjeta que tu le indiques para que este en modo monitor (necesario)

- Se cambia la direccion MAC con Macchanger para ser aun mas anonimos 

### 1) Handshake Attack

- Nos saldra una ventana con todas las redes disponibles y sus canales, le debemos indicar el nombre correctamnete de la red y su canal

- Luego nos saldra una ventana igual, solo que ahora estara filtrada por el nombre y el canal que le pasamos anteriormente

- Esperamos unos segundos y empezara el ataque a la red

- Despues de algunos segundos vamos a optener un Handshake

- Nos preguntara por algun diccionario que queramos usar, igual se dara la ruta de rockyou.txt por si quieres usar ese diccionario (El rockyou en kali esta comprimido, para descomprimir el archivo debemos aplicar estos comandos): 
```
cd /usr/share/wordlists

gunzip -d rockyou.txt.gz
```

- Luego se hara fuerza bruta con el diccionario que le pasamos (Durara bastante dependiendo de tu computadora y de la contraseña)

### 2) PMKID Attack

- Esperara el paquete necesario por los segundos que le indiquemos

- Si lo captura pasara a la fase de fuerza bruta con hashcat

- Si no lo captura se cerrara el ataque

### 3) DoS Attack

- Nos preguntara por la red que ke queremos hacer el ataque

- Luego por los canales, los recomendados son el 1,6,11 pero puedes poner todos del 1-12 o los que guste 

- Puede que la red cambie de canales

### 4) Beacon Flood Attack

- Nos preguntara si queremos ponerle nombre a la red, si le damos que si (Y) nos preguntara el nombre y empazara

- (Recomendado) Si le damos que no (N) pues se nos hara un flood de redes con nombre extraños

### 5) Scanner

- Nos buscara los dispotivos de nuestra red y se nos mostrara por pantalla con la ip

### 6) Ataque evilTrust

- Despliegue automatizado de un Rogue AP con capacidad de selección de plantilla + 2FA.

- Si quieres apoyar al creador y ver mas sobre la herramienta: https://github.com/s4vitar/evilTrust

- Le estare haciendo modificaciones al codigo, ya que esta desactualizado pero el creador seguira siendo S4vitar

### 7) Fuerza bruta .cap

- Nos hara fuerza bruta a un handshake .cap

### 8) Rainbow Taibles

- Es un diccionario precomputado para ser usado contra hashes, esto nos ayudara a que sea mas rapido (Depende de la contraseñas)
