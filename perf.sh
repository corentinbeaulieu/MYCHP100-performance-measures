
#!/bin/bash

# Définition des variables
SCR_DIR=Scripts
BIN_DIR=dgemm #dotprod reduc
CC='gcc clang' # icx
OFLAGS='-O0 -O1 -O2 -O3 -Ofast'

# Récupération des information sur la machine
$SCR_DIR/arch.sh

# dgemm

for actual_dir in $BIN_DIR
do
  cd $actual_dir 
  rm -f *.dat

  for oflag in $OFLAGS
  do
    for cc in $CC 
    do
       make clean 
       make CC=$cc OFLAGS=$oflag 
       printf "RUNNING %7s %5s %6s\n" $actual_dir $cc $oflag
       taskset -c 1 ./$actual_dir 100 10
       for data_file in $( ls | grep .dat )
       do
         printf "%5s %6s\n" $cc $oflag >> $data_file
       done
    done
  done
  cd ..
  gnuplot $SCR_DIR/plot-$actual_dir.gp
done
