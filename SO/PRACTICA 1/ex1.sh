#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi
directori=$1

if [ ! -d $directori ]
then
    echo "El fitxer no és un directori"
    exit 1
fi

if [ ! "$(ls $directori)" ]
    then
        echo "El directori està buit"
        exit 1
else

    llistat_ordenat=($(ls -S $directori))
    i=0
    trobat=0
    while [ $i -lt ${#llistat_ordenat[*]} ] && [ $trobat -eq 0 ]
    do
	if [ -f $1${llistat_ordenat[$i]} ]
	then
		trobat=1
		archiu=${llistat_ordenat[$i]}
		info=($(ls -l $1$archiu))
        fi
	i=$(($i+1))
    done
    echo "Fitxer mes gran:  "$archiu", "${info[4]}" bytes"
fi
