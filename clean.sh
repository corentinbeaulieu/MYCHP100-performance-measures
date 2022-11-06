
#!/bin/bash

BIN_DIR='dgemm dotprod reduc'

for actual_dir in $BIN_DIR
do
    # Delete gnuplot scripts
    rm -f plot-$actual_dir.gp
    rm -f multiplot-$actual_dir.gp
    # Delete executable and .dat files
    cd $actual_dir
    make clean
    cd ..
done

