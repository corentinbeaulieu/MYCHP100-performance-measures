
set terminal png size 1200,800

set grid y

set auto x
set xlabel "Compiler"

set ylabel "MiB/s"

set style data histogram
set style histogram errorbars gap 2 lw 1

unset xtics

set xtics rotate by -45 scale 0
set datafile separator ";"

set style fill solid 0.8 noborder 

set errorbars linecolor black
set bars front

set key left top

