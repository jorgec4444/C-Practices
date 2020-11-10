#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

directori=$1

if [ ! -d $directori ] || [ ! "$(ls $directori)" ]
then
    echo "El directori no existeix o està buit"
    exit 1
fi

llista=$(find $directori -type  d)
for element in $llista
do
  echo "Directori: $element"
  sorted_files=$(find $element -maxdepth 1 -type f -printf "%s\t%P\n" | sort -nr | head -n 3 )
  echo $sorted_files
  echo " "
done
exit 0
