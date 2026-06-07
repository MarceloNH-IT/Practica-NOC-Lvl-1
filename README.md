# Practica-NOC-Lvl-1
Práctica de configuración de red, mantenimiento de sistema y despliegue de servidor web en Linux (Debian/Ubuntu).
# 🖥️ Laboratorio NOC Lvl 1
Práctica de configuración de red, mantenimiento de sistema y despliegue de servidor web en Linux (Debian/Ubuntu).

---

## 📋 Descripción
Este laboratorio reproduce un desafío típico de NOC Lvl 1:
- Configuración de red estática.
- Actualización y mantenimiento del sistema.
- Instalación y despliegue de Nginx.
- Validación local del servicio web.

---

## 🚀 Fase 1: Configuración de Red Estática
Configura la red para que sea persistente y no dependa de DHCP.

1. Editar archivo de configuración:
   ```bash
   sudo nano /etc/netplan/01-netcfg.yaml
Ejemplo de configuración (IPs ficticias):
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses: [192.168.50.100/24]
      gateway4: 192.168.50.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
Aplicar cambios:
sudo netplan apply
Validar:
ip addr show
ping -c 4 192.168.50.1

---
---

## 🔧 Fase 2: Mantenimiento y Actualización

Mantén el sistema actualizado y seguro ejecutando las siguientes directivas secuencialmente:

* **Paso 1 (Sincronizar e instalar actualizaciones estándar):** `sudo apt update && sudo apt upgrade -y`

* **Paso 2 (Actualizar dependencias críticas y Kernel):** `sudo apt dist-upgrade -y`

* **Paso 3 (Depurar paquetes huérfanos del sistema):** `sudo apt autoremove -y`

---

## 🌐 Fase 3: Despliegue de Servidor Web

Instala y aprovisiona el servidor web Nginx asegurando su persistencia en la infraestructura operativa:

* **Paso 1 (Instalar el paquete oficial):** `sudo apt install nginx -y`

* **Paso 2 (Habilitar persistencia en el arranque):** `sudo systemctl enable nginx`

* **Paso 3 (Levantar el servicio inmediatamente):** `sudo systemctl start nginx`

* **Paso 4 (Auditar el estado operativo actual):** `sudo systemctl status nginx --no-pager`

---

## 🧪 Fase 4: Validación Local

Comprueba la disponibilidad del servicio web inspeccionando de forma interna los códigos de retorno HTTP:

* **Paso 1 (Validación de cabeceras de red):** `curl -I http://localhost`

* **Paso 2 (Validación de descarga del index local):** `wget -qO- http://127.0.0.1`

**Resultado esperado:** El sistema debe reflejar la cabecera operativa de Nginx o volcar las primeras líneas del archivo HTML estándar de bienvenida.

###  📂 Estructura del Proyecto
noc-practica/

README.md

docs/

fase1_red.md
fase2_update.md
fase3_nginx.md
fase4_validacion.md

capturas/

red.png
update.png
nginx.png
validacion.png
scripts/
setup.sh

📊 Criterios de Evaluación
Persistencia de cambios tras reinicio.

Uso correcto de privilegios (sudo).

Servicio web activo y accesible.

Validación local con herramientas nativas (ping, curl, wget).

✅ Checklist
[ ] Red configurada y persistente

[ ] Sistema actualizado

[ ] Nginx instalado y activo

[ ] Validación local exitosa

Última actualización: 2026-06-07
Versión: 1.0
Estado: ✅ Laboratorio listo para práctica


## 📂 Scripts
Este laboratorio también incluye un script automatizado:

---

---

## 📘 Anexo Técnico: Uso de `sudo` en Soporte de Redes (NOC)

El comando `sudo` (**S**uper**u**ser **DO**) permite a un usuario estándar ejecutar tareas críticas con los privilegios del **Superusuario (Root)** de forma segura y controlada, sin necesidad de compartir contraseñas maestras.

### 📊 Tabla Comparativa de Privilegios

| Característica / Acción | Usuario Estándar | Usuario con `sudo` | Superusuario (`root`) |
| :--- | :--- | :--- | :--- |
| **Nivel de Permisos** | Mínimos (Solo su entorno) | Temporales y controlados | Totales e ilimitados |
| **Configurar Red / Servicios** | ❌ Denegado |  Permitido |  Permitido |
| **Registro en Logs (Auditoría)** | No aplica |  **Sí (Registra quién lo usó)** | ❌ No (Anónimo) |
| **Riesgo Operativo** | Nulo | 🟢 Mitigado |  **Crítico (Peligro de borrado)** |

---

### ¿Por qué es obligatorio en un NOC Lvl 1?

1. **Modificación de Red:** Configurar interfaces, rutas IP y archivos como Netplan requiere permisos del núcleo del sistema.
2. **Gestión de Servicios:** Iniciar, detener o reiniciar daemons esenciales (como Nginx o SSH) mediante `systemctl` está restringido por seguridad.
3. **Principio de Menor Privilegio:** Operar siempre con `sudo` (y nunca directamente como `root`) garantiza la **trazabilidad** (saber quién hizo qué cambio si algo falla) y actúa como barrera contra errores de tipeo accidentales en producción.

---

### ⏱️ Comando Rápido de Diagnóstico ante Incidentes (Checklist de Consola)

Cuando un nodo perimetral o un servicio reporta fallas, seguí este orden lógico de comandos en la terminal:

1. **¿El hardware de red responde localmente?** `ip addr show` (Verificá que tu interfaz no esté en *DOWN*).
2. **¿Llegamos al switch o router local?** `ping -c 4 <Tu_Puerta_De_Enlace>` (Prueba de Capa 3 interna).
3. **¿Tenemos salida a Internet / WAN?** `ping -c 4 8.8.8.8` (Prueba de conectividad externa por IP).
4. **¿Está funcionando el servidor DNS?** `nslookup google.com` (Verificá si el DNS resuelve el nombre).
5. **¿El servicio web está escuchando conexiones?** `sudo ss -tulpn | grep :80` (Confirmá que el puerto 80 esté activo para Nginx).

### ⏱️ Ejemplo de Diagnóstico ante Incidentes (Metodología NOC Lvl 1)

Cuando un nodo perimetral o un servicio reporta fallas, seguí este orden lógico paso a paso en la terminal para aislar el problema de inmediato utilizando direccionamiento seguro de laboratorio:

| Paso | Verificación Operativa | Comando de Diagnóstico | Ejemplo de Comando Real | Salida Esperada (Éxito) |
| :---: | :--- | :--- | :--- | :--- |
| **1** | ¿El hardware de red responde localmente? | `ip addr show <interfaz>` | `ip addr show ens33` | Debe mostrar la interfaz en estado **`state UP`** y reflejar tu IP estática de pruebas (`192.168.1.100`). |
| **2** | ¿Llegamos al switch o router local? | `ping -c 4 <Gateway>` | `ping -c 4 192.168.1.1` | Debe retornar **`0% packet loss`** y tiempos de respuesta bajos (baja latencia en la LAN). |
| **3** | ¿Tenemos salida hacia Internet (WAN)? | `ping -c 4 <IP_Pública_Segura>` | `ping -c 4 1.1.1.1` | Debe dar respuesta exitosa desde la IP pública de DNS de Cloudflare, descartando cortes en el proveedor (ISP). |
| **4** | ¿Está funcionando la resolución de nombres? | `nslookup <Dominio>` | `nslookup google.com` | Debe devolver la IP del servidor DNS local utilizado (`192.168.1.1`) y la respuesta con la IP del dominio consultado. |
| **5** | ¿El servicio web está escuchando conexiones? | `sudo ss -tulpn \| grep :<Puerto>` | `sudo ss -tulpn \| grep :80` | Debe mostrar una línea con el estado **`LISTEN`** asociada al proceso `nginx` en el puerto estándar 80. |

   ---

## 🛠️ Guía Rápida de Comandos para Operador NOC Lvl 1

Para facilitar el estudio y el seguimiento rápido en la consola, esta tabla resume las herramientas nativas indispensables en Linux (Debian/Ubuntu) organizadas por su función operativa dentro del Centro de Operaciones de Red:

| Categoría | Comando Base | Propósito Técnico en el NOC | Ejemplo de Uso |
| :--- | :--- | :--- | :--- |
| **Capa 3 / ICMP** | `ping` | Valida conectividad básica y pérdida de paquetes. | `ping -c 4 192.168.1.1` |
| **Ruta / Saltos** | `traceroute` / `mtr` | Diagnostica en qué nodo o salto de la red hay latencia o corte. | `traceroute 8.8.8.8` |
| **Tabla de Rutas** | `ip route` | Muestra la puerta de enlace (Gateway) activa del servidor. | `ip route show` |
| **Direccionamiento**| `ip addr` | Verifica las IPs asignadas y si la interfaz está activa (UP). | `ip addr show ens33` |
| **Persistencia** | `netplan apply` | Aplica y valida configuraciones de red estructuradas en YAML. | `sudo netplan apply` |
| **Resolución DNS** | `nslookup` / `dig` | Comprueba si el servidor DNS resuelve nombres de dominio. | `nslookup google.com` |
| **Servicios / Daemons**| `systemctl` | Administra el estado, inicio o reinicio de servicios (Nginx, SSH).| `sudo systemctl status nginx` |
| **Puertos / Sockets**| `ss` / `netstat` | Muestra qué puertos lógicos están abiertos y escuchando tráfico. | `sudo ss -tulpn` |
| **Paquetes / OS** | `apt` | Sincroniza repositorios e instala parches de seguridad críticos. | `sudo apt update && sudo apt upgrade -y` |

---

## 📊 Estadísticas del Repositorio

 
![Streak Stats](https://github-readme-streak-stats.herokuapp.com/?user=MarceloNH-IT&theme=radical)  
![Profile Views](https://komarev.com/ghpvc/?username=MarceloNH-IT&color=blue&style=flat)


# 📊 Resumen del Éxito del Laboratorio


## ✅ Conclusión

🚀 Fase 1: Configuración de Netplan  
Comando aplicado:  
Fase 1: Configuración de Netplan aplicada con éxito.  
![Fase 1](F1.jpeg)

🔧 Fase 2: Mantenimiento del Sistema  
Comando aplicado:  
Fase 2: Mantenimiento base del sistema ejecutado.  
![Fase 2](F2.jpeg)

🌐 Fase 3: Despliegue de Nginx  
Comando aplicado:  
Fase 3: Despliegue y automatización del arranque de Nginx completados.  
![Fase 3](F3.jpeg)

🧪 Fase 4: Validación Local HTTP  
Comandos aplicados:  
Fase 4: Diagnóstico y verificación local HTTP exitosos usando herramientas nativas (`curl` y `wget`).  
![Fase 4](F4.jpeg)

**Estado final:** 🟩 Laboratorio completado y documentado para portafolio.


# 🖥️ Script de Automatización - Laboratorio NOC Lvl 1

Este script (`setup.sh`) automatiza las 4 fases del laboratorio:

1. Configuración de red persistente con Netplan.  
2. Mantenimiento y actualización del sistema operativo.  
3. Instalación y despliegue de Nginx.  
4. Validación local del servicio web con `curl` y `wget`.

---

## 📂 Evidencias del Script

### 🚀 Fase 0: Inicio del despliegue
![Script 0](Script0.jpeg)

### 📡 Fase 1: Configuración de Red
![Script 1](Script1.jpeg)

### 🔧 Fase 2: Mantenimiento del Sistema
![Script 2](Script2.jpeg)

### 🌐 Fase 3: Instalación de Nginx
![Script 3](Script3.jpeg)

### ⚙️ Fase 3b: Habilitación y arranque de Nginx
![Script 4](Script4.jpeg)

### 🧪 Fase 4: Validación con curl
![Script 5](Script5.jpeg)

### 🧪 Fase 4b: Validación con wget
![Script 6](Script6.jpeg)

---

## ✅ Estado Final
🟩 Script ejecutado con éxito y validado para portafolio.









