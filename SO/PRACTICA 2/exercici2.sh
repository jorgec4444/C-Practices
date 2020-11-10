#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Nombre de paràmetres incorrectes"
    exit 1
fi

directori=$1
cad1=$2
cad2=$3

if [ ! -d $directori ] || [ ! "$(ls $directori)" ]
then
    echo "El directori no existeix o està buit"
    exit 1
fi

llista=$(find $directori -type f)
for file in $llista
do
  paraules=$(grep -o "$cad1\S*$cad2" $file | wc -w)
  #Comprovar si l'arxiu conté paraules/és legible.
  #if [ $paraules -gt 0 ]
  #then
  echo $file ", paraules: " $paraules
  #fi
done
exit 0
