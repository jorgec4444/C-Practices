#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

dir="$(pwd)/etc" #serà path/etc/passwd o /group tal i com posava al correu.

file_passwd=$(grep $1 $dir/passwd)

user=$(echo "$file_passwd" | awk '{print $1}')

#Comprovar si l'usuari existeix
if [ -z "$user" ]
then
    echo "L'usuari especificat no existeix en aquest ordinador."
    exit 1
else
    username=$(echo $file_passwd | awk -F: '{print $5}')
    user_id=$(echo $file_passwd | awk -F: '{print $3}')
    root_dir=$(echo $file_passwd | awk -F: '{print $6}')
    interpreter=$(echo $file_passwd | awk -F: '{print $7}')

    #Primer fico els users.
    group_id=$(echo $file_passwd | awk -F: '{print $4}')
    file_group=$(grep $1 $dir/group)
    group_list="$(echo "$(grep $group_id $dir/group | awk -F: '{print $1}') ($group_id)")," 

    #Aquí itero pels grups que coincideixen amb "lluis".
    for groupp in $(sed "s/:/ /g" $dir/group | grep $1 | awk '{print $1}')
    do
      group_list="$group_list $(echo "$groupp ($(sed "s/:/ /g" $dir/group | grep $groupp | awk '{print $3}' ))"),"
    done

    echo "Nom de l'usuari:" $username
    echo "Identificador de l'usuari:" $user_id
    echo "Grups als qual pertany l'usuari:" $group_list
    echo "Directori arrel de l'usuari:" $root_dir
    echo "Intèrpret per defecte:" $interpreter
fi
exit 0
