#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Nombre de paràmetres incorrecte."
    exit 1
fi

users=$(ps -aux | awk '{print $1}' | grep $1)

if [[ $users == "" ]]
then
    echo "En $1 no té cap procés associat."
    exit 1
fi


if [[ $2 != "VSZ" && $2 != "RSS" ]]
then
    echo "El segon argument ha de ser VSZ o RSS."
    exit 1
fi

type=$2

ps aux --sort "-${type,,}" | head -n 11 | awk {'printf ("%s\t%s\t%s\n", $5, $6, $11)'}
exit 0
