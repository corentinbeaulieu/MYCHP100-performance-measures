#!/bin/bash


PROC_FILE=/proc/cpuinfo
CACHE_DIR=/sys/devices/system/cpu/cpu0/cache/index
INFO_FILE=Rapport/arch-info.txt
COMPILERS='gcc clang icc icx'

# CPU Information

echo -e "##### General CPU Informations #####\n" > $INFO_FILE
cat $PROC_FILE >> $INFO_FILE

echo -e "\n### Frequency Info ###\n" >> $INFO_FILE
cpupower frequency-info >> $INFO_FILE 

# Caches Information

echo -e "\n\n##### Caches Informations #####\n" >> $INFO_FILE

for i in 0 2 3
do
  
  if [ $i -eq 0 ]
  then
    echo -e "\n### Cache l1 ###\n" >> $INFO_FILE
  else
    echo -e "\n### Cache l$i ###\n" >> $INFO_FILE
  fi

  index_files=$( ls $CACHE_DIR$i 2>/dev/null)
  if [ $? -ne 0 ]
  then
    echo "DOES NOT EXIST ON THIS ARCHITECTURE" >> $INFO_FILE
  fi

  for file in $index_files
  do

    echo "$file : $( cat $CACHE_DIR$i/$file )" >> $INFO_FILE

  done

done

# Compilers info
echo -e "\n\n##### Compilers Info #####\n\n" >> $INFO_FILE

for cc in $COMPILERS
do
    echo -e "\n### $cc ###\n" >> $INFO_FILE
    $cc --version 1>> $INFO_FILE 2>/dev/null
    if [ $? -ne 0 ]
    then
       echo "Compiler not found on this computer" >> $INFO_FILE
    fi
done

