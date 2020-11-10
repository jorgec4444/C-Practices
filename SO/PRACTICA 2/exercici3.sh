#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

directori=$1

if [ ! -d $1 ] || [ ! "$(ls $directori)" ]
then
    echo "El directori especificat no conté cap fitxer o no existeix"
    exit 1
fi

ext=$2
weight=$3
mkdir fitxers
ruta="$(pwd)/fitxers"

if [ $(find $directori -type f -size +$weight | grep .$ext | wc -w) -gt 0 ]
then
    cp $(find $directori -type f -size +$weight | grep .$ext) $ruta
fi

if [ ! "$(ls $ruta)" ]
then
    echo "No hi ha cap fitxer que cumpleixi amb les condicions especificades"
    exit 1
fi

tar -czf fitxers.tar.gz fitxers
echo "He comprimit els fitxers a fitxers.tar.gz"
rm -r fitxers
exit 0
