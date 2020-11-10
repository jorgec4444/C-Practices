#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Nombre de paràmetres incorrecte"
    exit 1
fi

directori=$1

if [ ! "$(ls $directori)" ] || [ ! -d $directori ]
    then
        echo "El directori especificat no conte cap fitxer"
        exit 1
fi

cad1=$2
cad2=$3
length1=${#cad1}
length2=${#cad2}
files_list=$(ls $directori)
cnt=0

for file in $files_list
do
  if [ -f $directori$file ]
  then
      file_words=$(cat $directori$file)
      for word in $file_words
      do
        length_w=${#word}
        if [ "${word:0:$length1}" = $cad1 ]
        then
	    if [ "${word:$length_w-$length2:$length2}" = $cad2 ]
	    then
                echo "$file:$word"
		cnt=$(( cnt + 1 ))
	    fi
        fi
      done
  fi
done

echo $cnt
exit 0
