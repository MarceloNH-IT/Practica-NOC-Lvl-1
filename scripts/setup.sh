#!/bin/bash
# 🖥️ Script de Automatización - Laboratorio NOC Lvl 1
# Configuración de red persistente, mantenimiento de OS y despliegue de Nginx.

# --- Configuración de Variables de Red (Rango Privado Seguro) ---
IP="192.168.50.100/24"
GATEWAY="192.168.50.1"
DNS1="8.8.8.8"
DNS2="1.1.1.1"
INTERFACE="ens33"

echo "=========================================================="
echo "🚀 Iniciando Despliegue Automatizado - NOC Lvl 1"
echo "=========================================================="

# --- Fase 1: Configuración de Red Estática ---
echo -e "\n📡 [Fase 1] Configurando red estática persistente..."

sudo tee /etc/netplan/01-netcfg.yaml > /dev/null <<EOL
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $IP
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$DNS1, $DNS2]
EOL

echo "🔄 Aplicando cambios de Netplan..."
sudo netplan apply
echo "✅ Red configurada con éxito en la interfaz $INTERFACE"

# --- Fase 2: Mantenimiento y Actualización ---
echo -e "\n🔧 [Fase 2] Sincronizando repositorios y aplicando parches de seguridad..."
sudo apt update && sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y && sudo apt clean
echo "✅ Sistema operativo actualizado y depurado."

# --- Fase 3: Despliegue de Servidor Web ---
echo -e "\n🌐 [Fase 3] Instalando y aprovisionando Nginx..."
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
echo "✅ Servicio Nginx activo y persistente en el arranque."

# --- Fase 4: Validación Local ---
echo -e "\n🧪 [Fase 4] Ejecutando pruebas de disponibilidad locales..."
echo "----------------------------------------------------------"
echo "📥 Verificando cabeceras HTTP (curl):"
curl -I http://localhost
echo "----------------------------------------------------------"
echo "📥 Descargando primeras líneas de Loopback (wget):"
wget -qO- http://127.0.0.1 | head -n 5
echo "----------------------------------------------------------"

echo -e "\n🟢 ¡Laboratorio completado con éxito y validado para entorno de pruebas!"
echo "=========================================================="
