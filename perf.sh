
#!/bin/bash

# Définition des variables
SCR_DIR=Scripts
BIN_DIR=dgemm #dotprod reduc
RES_DIR=RESULTS
CC='gcc clang' # icx
OFLAGS='-O0 -O1 -O2 -O3 -Ofast'
PLOT_BASE=$SCR_DIR/plot-base.gp
N=300
R=10

# preparing Results repository
rm -rf $RES_DIR
mkdir $RES_DIR

# Get computer information
RES_DIR=$RES_DIR $SCR_DIR/arch.sh 

# dgemm

for actual_dir in $BIN_DIR
do
  # preparing gnuplot script
  plot_scr=plot_$actual_dir.gp
  rm $plot_scr

  cp $PLOT_BASE $plot_scr
  echo -e "set title \"Performance $actual_dir n=$N en fonction de l'implémentation \
et des options de compilation\"" >> $plot_scr
  echo -e "set output \"$RES_DIR/plot-$actual_dir$N.png\"" >> $plot_scr

  printf "plot " >> $plot_scr
  
  # proceed benchmarks
  cd $actual_dir 
  make clean

  for oflag in $OFLAGS
  do
    for cc in $CC 
    do
       touch main.c
       make CC=$cc OFLAGS=$oflag 
       printf "RUNNING %7s %5s %6s\n" $actual_dir $cc $oflag
       taskset -c 1 ./$actual_dir $N $R
       for data_file in $( ls | grep .dat )
       do
         printf "%5s %6s\n" $cc $oflag >> $data_file
       done
    done
  done

  # plot the data obtained
  cd ..
  for data_file in $( ls $actual_dir | grep .dat )
  do
      echo -e "\"$actual_dir/$data_file\" u 10:(\$9/\$7*\$10):xtic(11)\
 t \"$( echo $data_file | cut -d '.' -f 1 )\", \\" >> $plot_scr
  done
  gnuplot $plot_scr
done
