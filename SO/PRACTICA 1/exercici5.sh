#!/bin/bash

if [ $# -ne 4 ]
then
    echo "Nombre de parametres incorrecte"
    exit 1
fi

directori=$1

if [ ! "$(ls $directori)" ] || [ ! -d $directori ]
    then
        echo "El directori especificat no conte cap fitxer o no existeix"
        exit 1
fi

ext1=$2
ext2=$3
ext3=$4
cnt_ext1=0
cnt_ext2=0
cnt_ext3=0

files_list="$(ls $directori)"
for file in $files_list
do
  if [ -d $directori$file ]
  then
      ./$0 "$directori$file/" $ext1 $ext2 $ext3
  fi

  if [ -f $directori$file ]
  then
      file_ext=${file##*.}
      if [ $file_ext = $ext1 ]
      then
	  cnt_ext1=$(( $cnt_ext1 + 1 ))
      fi
      if [ $file_ext = $ext2 ]
      then
	  cnt_ext2=$(( $cnt_ext2 + 1 ))
      fi
      if [ $file_ext = $ext3 ]
      then
	  cnt_ext3=$(( $cnt_ext3 + 1 ))
      fi
  fi
done

echo "$directori $ext1:$cnt_ext1 $ext2:$cnt_ext2 $ext3:$cnt_ext3"
exit 0
