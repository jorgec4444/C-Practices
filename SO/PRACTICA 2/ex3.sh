
#!/bin/bash


if [ $# -ne 3 ]
then 
	echo "Nombre de paràmetres incorrecte"
	exit 1
fi
directori=$1
echo $pes
if [ ! -d $directori ]
then
	echo "El fitxer no és un directori"
	exit 1
fi
if [ ! "$(ls $directori)" ]
then
        echo "El directori està buit" 
else
   if [ $(find $1 -type f -size +$3 | grep .$2| wc -w) -gt 1 ]
   then
	mkdir fitxers
	cp $(find $1 -type f -size +$3 | grep .$2) fitxers
  fi
  if [ ! "$(ls $ruta)" ]
  then
	echo "No hi ha cap fitxer que cumpleixi amb les condicions especificades"
  	exit 1
  fi 
  tar -czf fitxers.tar.gz fitxers
  echo "He comprimit els fitxers a fitxers.tar.gz"
  rm -r fitxers

fi
