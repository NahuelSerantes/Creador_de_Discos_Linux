# Creador_de_Discos_Linux
Script interactivo en Bash para crear discos .img, asignar dispositivos loop automáticamente y formatearlos con distintos sistemas de archivos en Linux.

# Creador de discos .img en Linux (Bash)

Script interactivo en Bash para crear discos virtuales `.img` en Linux.

El programa permite crear múltiples discos, asignar automáticamente dispositivos **loop** y formatearlos con diferentes sistemas de archivos.

Es ideal para practicar administración de almacenamiento en Linux.
---

## Funcionalidades

✔ Crear múltiples discos virtuales  
✔ Elegir tamaño del disco  
✔ Seleccionar unidad (K, M, G)  
✔ Asignar automáticamente dispositivos loop  
✔ Formatear el disco en distintos sistemas de archivos  

Sistemas de archivos disponibles:

- ext4
- ext3
- ext2
- xfs
- btrfs

---

##  Casos de uso

Este script es útil para practicar:

- creación de discos virtuales
- dispositivos **loop**
- sistemas de archivos
- montaje de discos
- laboratorios de Linux
- pruebas de almacenamiento

---

##  Requisitos

Sistema Linux con:

- `bash`
- `losetup`
- `mkfs`

Herramientas opcionales:
xfsprogs
btrfs-progs

Instalar si es necesario:

sudo apt install xfsprogs btrfs-progs


## Instalación
Clonar el repositorio:
git clone https://github.com/TU-USUARIO/Creador_de_Discos_Linux.git

Entrar al directorio:
cd creador-discos-linux-bash

Dar permisos de ejecución al script
chmod +x crear_discos_pro.sh

Ejecutar el script:
./crear_discos_pro.sh

## Posibles mejoras futuras

- Opción de montar automáticamente el disco
- Liberar el loop automáticamente
- Crear particiones
- Integración con LVM
- Automatizar desmontaje


