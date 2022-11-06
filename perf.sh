
#!/bin/bash

# Variable definition
SCR_DIR=Scripts
BIN_DIR="dgemm dotprod reduc"
RES_DIR=RESULTS
CC_potential='gcc clang icc icx'
OFLAGS='-O0 -O1 -O2 -O3 -Ofast'
PLOT_BASE=$SCR_DIR/plot-base.gp
N=128
R=33

# Preparing Results repository
rm -rf $RES_DIR
mkdir $RES_DIR

# Get computer information
RES_DIR=$RES_DIR $SCR_DIR/arch.sh 

# Verify compilers available
compiler=0
CC=""

for cc in $CC_potential
do
  $cc --version 1>/dev/null 2>/dev/null
  if [[ $? -eq 0 ]]
  then
    CC=$CC" "$cc
    compiler=1
  fi
done

if [[ $compiler -eq 0 ]]
then
    echo -e "No suitable compiler found\nPlease get one of those : $CC_potential"
else

# Main loop
for actual_dir in $BIN_DIR
do
 
  # Proceed benchmarks
  cd $actual_dir 
  make clean

  for oflag in $OFLAGS
  do
    for cc in $CC 
    do
       touch main.c
       make CC=$cc OFLAGS=$oflag 
       printf "RUNNING %7s %5s %6s benchmark\n" $actual_dir $cc $oflag
       taskset -c 1 ./$actual_dir $N $R
       i=0
       for data_file in $( ls | grep .dat )
       do
         printf "%5s %6s\n" $cc $oflag >> $data_file
         i=$(( $i + 1 ))
       done
    done
  done

  # Plot the data obtained
  cd ..
  # Preparing gnuplot script
  plot_scr=plot-$actual_dir.gp
  rm -f $plot_scr

  cp $PLOT_BASE $plot_scr
  echo -e "set terminal png size 1200,700" >> $plot_scr
  echo -e "set output \"$RES_DIR/plot-$actual_dir$N.png\"\n" >> $plot_scr

  printf "plot " >> $plot_scr
  for data_file in $( ls $actual_dir | grep .dat )
  do
      echo -e "\"$actual_dir/$data_file\" u 11:(\$10/\$9*\$11):xtic(12)\
 t \"$( echo $data_file | cut -d '.' -f 1 )\", \\" >> $plot_scr
  done
  gnuplot $plot_scr
  echo "PLOT GENERATED : $RES_DIR/plot-$actual_dir$N.png"
  
  # Multiplot the data obtained
  # Preparing gnuplot script
  plot_scr=multiplot-$actual_dir.gp
  rm -f $plot_scr

  cp $PLOT_BASE $plot_scr
  echo -e "set terminal png size 1200,1000" >> $plot_scr
  echo -e "set output \"$RES_DIR/multiplot-$actual_dir$N.png\"\n" >> $plot_scr

  echo "set multiplot layout $(($i/2 + $i%2)),2 rowsfirst" >> $plot_scr
  echo "unset xlabel" >> $plot_scr
  i=1
  for data_file in $( ls $actual_dir | grep .dat )
  do
      # Show ylabel only for the first column
      if [[ $(( $i%2 )) -eq 1 ]]
      then
          echo -e "set ylabel \"Mio/s\"" >> $plot_scr
      else
          echo -e "unset ylabel" >> $plot_scr
      fi
      # Set title to each graph
      echo -e "set title \"$( echo $data_file | cut -d '.' -f 1 )\"" >> $plot_scr
      echo -e "plot \"$actual_dir/$data_file\" u 11:(\$10/\$9*\$11):xtic(12) notitle lc \"grey20\"" >> $plot_scr
      i=$(( i + 1 ))
  done
  echo "unset multiplot" >> $plot_scr
  gnuplot $plot_scr
  echo "PLOT GENERATED : $RES_DIR/multiplot-$actual_dir$N.png"

  # Set N for the dotprod and reduc
  N=$(( 2 ** 20 ))
done
fi

# Clean all temporary files (.dat .gp)
./clean.sh
