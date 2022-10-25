
reset

set grid y

set auto x
set xlabel "Compiler"

set ylabel "MiB/s"

set errorbars
set style histogram errorbars 

unset xtics

set xtics rotate by -45 scale 0
set datafile separator ";"

set style fill transparent solid 0.8 noborder

plot "../dgemm/IJK.dat" u 10:9:xtic(11) t "performance" 
pause -1
