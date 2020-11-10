#!/bin/bash

if [ $# -ne 1 ]
then
    echo "El nombre de paràmetres és incorrecte"
    exit 1
fi

directori=$1

if [ ! "$(ls $directori)" ] ||  [ ! -d $directori ]
then
    echo "El directori especificat no conte cap fitxer o no existeix"
    exit 1
fi

llista=$(find $directori -type d)

for file in $llista
do
  fitxers=$(find $file -maxdepth 1 -type f | wc -l)
  echo "directori:" $file "nfiles:"$fitxers
done

exit 0
