
#!/bin/bash

DIR=dgemm #dotprod reduc

# dgemm

for actual_dir in $DIR
do
  cd $actual_dir 
  rm -f *.dat
  for cc in gcc clang 
  do
     make clean 
     make CC=$cc 
     ./$actual_dir 100 10
     for data_file in $( ls | grep .dat )
     do
       printf "%10s\n" $cc >> $data_file
     done
  done

done
