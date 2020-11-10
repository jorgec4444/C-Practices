#!/bin/bash

if [ $# -lt 2 ]
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
else
  i=1
  parametres=($@)
  llista_extensions=""
  while [ $i -lt $# ]
  do
    ((${parametres[i]}=0))
    llista_extensions=$llista_extensions" "${parametres[i]}
    i=$((i + 1))
  done
  for i in $(ls $directori)
  do
      if [ -f $1$i ]
      then
	aux=1 
	while [ $aux -lt $# ] 
	do
	   extensio_par=${parametres[aux]}
           extensio_fit=${i#*.}
           if [ $extensio_par = $extensio_fit ]
           then
	  	(($extensio_par=$(($extensio_par + 1))))
		aux=$#
	    fi
	    aux=$((aux + 1))
	done
      else
	./ex5.sh $1$i/$llista_extensions
      fi
  done
fi
aux=1
sortida=$1
while [ $aux -lt $# ]
do
    sortida=$sortida" "${parametres[aux]}": "$((${parametres[aux]}))
    aux=$((aux + 1))
done
echo $sortida
