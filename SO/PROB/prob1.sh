#!/bin/bash

if [ $# -ne 1 ]
then
   echo "Nombre de parametres incorrecte"
   exit 1
fi

fitxer=$1
cnt_exists=0
cnt_not_exists=0

if [ ! -f $1 ] || [ -d $1 ]
then
    echo "El fitxer no existeix o és un directori" 
    exit 1
fi

files_list=$(cat $fitxer)
for i in $files_list
do
  if [ -f $i ] || [ -d $i ]
  then
      cnt_exists=$((cnt_exists + 1))
  else
      cnt_not_exists=$((cnt_not_exists + 1))
  fi
done

echo "Existeixen " $cnt_exists
echo "No existeixen " $cnt_not_exists
exit 0
