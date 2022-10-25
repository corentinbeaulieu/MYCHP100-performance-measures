
set terminal png size 1200,800
set output 'Rapport/plot-dgemm.png'

set title "Performance d'une dgemm en fonction de l'implémentation et des options de compilation"

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

plot "dgemm/IJK.dat"     u 10:(($9/$7)*$10):xtic(11) t "IJK", \
     "dgemm/IKJ.dat"     u 10:($9/$7*$10):xtic(11) t "IKJ", \
     "dgemm/IEX.dat"     u 10:($9/$7*$10):xtic(11) t "IEX", \
     "dgemm/UNROLL4.dat" u 10:($9/$7*$10):xtic(11) t "UNROLL4", \
     "dgemm/UNROLL8.dat" u 10:($9/$7*$10):xtic(11) t "UNROLL8", \
     "dgemm/CBLAS.dat"   u 10:($9/$7*$10):xtic(11) t "CBLAS" 
