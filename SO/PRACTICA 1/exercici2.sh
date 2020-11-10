#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi
string=$1
length=${#string}

#For que itera des del final de la cadena fins al principi sense comptar
#la última lletra per a que no es dupliqui.
for (( i=$length-2; i >= 0; i-- ))
do
  reverse+="${string:i:1}" #afegint només una lletra a cada iteració (:1)
done

palindrome="$string$reverse" #ajunto el string original i el seu invers.

echo "Palindrom": $palindrome
exit 0
