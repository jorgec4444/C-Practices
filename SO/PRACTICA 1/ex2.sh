#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

paraula=($1)

num=$((${#paraula} - 2))
while [ $num -ge 0 ]
do
    paraula=$paraula${paraula:$num:1}
    num=$(($num - 1))
done
echo $paraula
