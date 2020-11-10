#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

directori=$1

if [ ! "$(ls $directori)" ] || [ ! -d $directori ]
    then
        echo "El directori especificat no conte cap fitxer o no existeix"
        exit 1
fi

extension=$2
mkdir fitxers
ruta="$(pwd)/fitxers"
files_list=$(ls $directori)
for file in $files_list
do
  if [ -f $directori$file ]
  then
      file_ext=${file##*.} #Elimina tot fins des del principi fins al punt.
      if [ $file_ext = $extension ]
      then
          cp $directori$file $ruta
      fi
  fi
done

if [ ! "$(ls $ruta)" ]
    then
        echo "El directori no conte cap fitxer amb l'extensio especificada"
        exit 1
fi

tar -czf fitxers.tar.gz fitxers   #-c(crear arxiu) -z(compresor gzip) -f(
                                  #proxim argument es el nom del fitxer.tar)
echo "He comprimit tots els fitxers d'extensio .$extension .Els tens a fitxers.tar.gz"
rm -r fitxers
exit 0
