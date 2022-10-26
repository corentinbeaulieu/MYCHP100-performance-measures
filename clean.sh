
#!/bin/bash

BIN_DIR='dgemm dotprod reduc'

for actual_dir in $BIN_DIR
do
    rm -f plot-$actual_dir.gp
    cd $actual_dir
    make clean
    cd ..
done

