#!/bin/bash

echo "========================================="
echo " CREADOR DE DISCOS .IMG + LOOP + FORMATO "
echo "========================================="
echo

read -p "¿En qué carpeta querés guardar los discos? " carpeta_destino

if [ ! -d "$carpeta_destino" ]; then
    echo "La carpeta no existe. Creándola..."
    mkdir -p "$carpeta_destino" || {
        echo "Error: no se pudo crear la carpeta."
        exit 1
    }
fi

echo
read -p "¿Cuántos discos querés crear? " cantidad

if ! [[ "$cantidad" =~ ^[0-9]+$ ]] || [ "$cantidad" -le 0 ]; then
    echo "Error: tenés que ingresar un número entero mayor que 0."
    exit 1
fi

echo
for ((i=1; i<=cantidad; i++)); do
    echo "---------------------------------"
    echo " Disco $i de $cantidad"
    echo "---------------------------------"

    read -p "Nombre del disco (sin extensión): " nombre
    read -p "Tamaño numérico (ej: 100): " tamano
    read -p "Unidad [K/M/G] (ej: M): " unidad

    if [ -z "$nombre" ]; then
        echo "Error: el nombre no puede estar vacío."
        exit 1
    fi

    if ! [[ "$tamano" =~ ^[0-9]+$ ]] || [ "$tamano" -le 0 ]; then
        echo "Error: el tamaño debe ser un número entero mayor que 0."
        exit 1
    fi

    unidad=$(echo "$unidad" | tr '[:lower:]' '[:upper:]')

    if [[ "$unidad" != "K" && "$unidad" != "M" && "$unidad" != "G" ]]; then
        echo "Error: la unidad debe ser K, M o G."
        exit 1
    fi

    archivo="$carpeta_destino/$nombre.img"

    if [ -e "$archivo" ]; then
        read -p "El archivo $archivo ya existe. ¿Querés sobrescribirlo? [s/n]: " resp
        resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')
        if [[ "$resp" != "s" ]]; then
            echo "Saltando $archivo..."
            echo
            continue
        fi
    fi

    echo
    echo "Creando archivo..."
    fallocate -l "${tamano}${unidad}" "$archivo" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo "fallocate no funcionó, probando con dd..."
        case "$unidad" in
            K) bs=1K ;;
            M) bs=1M ;;
            G) bs=1G ;;
        esac
        dd if=/dev/zero of="$archivo" bs="$bs" count="$tamano" status=progress
    fi

    if [ $? -ne 0 ]; then
        echo "Error al crear el archivo $archivo"
        echo
        continue
    fi

    echo "Archivo creado correctamente: $archivo"
    echo

    read -p "¿Querés asignarle un loop automáticamente? [s/n]: " usar_loop
    usar_loop=$(echo "$usar_loop" | tr '[:upper:]' '[:lower:]')

    loop_asignado=""

    if [[ "$usar_loop" == "s" ]]; then
        loop_asignado=$(sudo losetup --find --show "$archivo")
        if [ $? -eq 0 ]; then
            echo "Loop asignado correctamente: $loop_asignado"
        else
            echo "Error al asignar loop a $archivo"
            echo
            continue
        fi
    else
        echo "No se asignó loop."
    fi

    echo
    read -p "¿Querés formatearlo? [s/n]: " formatear
    formatear=$(echo "$formatear" | tr '[:upper:]' '[:lower:]')

    if [[ "$formatear" == "s" ]]; then
        echo "Formatos disponibles:"
        echo "  1) ext4"
        echo "  2) ext3"
        echo "  3) ext2"
        echo "  4) xfs"
        echo "  5) btrfs"
        read -p "Elegí una opción [1-5]: " opcion_fs

        case "$opcion_fs" in
            1) fs="ext4" ;;
            2) fs="ext3" ;;
            3) fs="ext2" ;;
            4) fs="xfs" ;;
            5) fs="btrfs" ;;
            *)
                echo "Opción inválida. Se omite el formateo."
                fs=""
                ;;
        esac

        if [ -n "$fs" ]; then
            # Si no eligió loop antes, lo asignamos ahora para poder formatear
            if [ -z "$loop_asignado" ]; then
                loop_asignado=$(sudo losetup --find --show "$archivo")
                if [ $? -ne 0 ]; then
                    echo "Error al asignar loop para formatear."
                    echo
                    continue
                fi
                echo "Loop asignado para formateo: $loop_asignado"
            fi

            echo "Formateando $loop_asignado en $fs..."

            case "$fs" in
                ext4) sudo mkfs.ext4 "$loop_asignado" ;;
                ext3) sudo mkfs.ext3 "$loop_asignado" ;;
                ext2) sudo mkfs.ext2 "$loop_asignado" ;;
                xfs)  sudo mkfs.xfs -f "$loop_asignado" ;;
                btrfs) sudo mkfs.btrfs -f "$loop_asignado" ;;
            esac

            if [ $? -eq 0 ]; then
                echo "Formateado correctamente en $fs"
            else
                echo "Error al formatear en $fs"
            fi
        fi
    else
        echo "No se formateó."
    fi

    echo
done

echo "========================================="
echo " Proceso finalizado"
echo "========================================="
