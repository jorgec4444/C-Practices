#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

directori=$1

if [ ! -d $directori ] || [ ! "$(ls $directori)" ]
then
    echo "El fitxer no és un directori o el directori està buit"
    exit 1
else
    sorted_list=$(ls -S $directori)
    for file in $sorted_list
    do
      if [ -f $directori$file ]
       then
           biggest_file=$file
	   info=($(ls -l $directori$biggest_file))
	   break
      fi
    done
fi

echo "Arxiu més gran" $biggest_file "amb" ${info[4]} "bytes"
exit 0
