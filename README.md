
# OBHPC Homework
---
Corentin Beaulieu 

---

## Description 

This repository is a student project which is to measure some linear algebra implementations and show the results. 
This repository contains all the source files and the report that aim to answer the homework given by Yaspr.

The subject can be found in the `TD2.odt` and `TD2.pdf` files.

The majority of the code have been written by Yaspr.
Some changes have been made to collect the performance measurements and add the few versions that were asked. 

The `perf.sh` script is used to automate the measurements and the presentation of the results.

The final report can be found in the `Rapport` directory.
The output of the automated measurements shown in the report are under `Rapport/Resulats`.

### Prerequisites

A Linux based operating system is needed.

In order to use the script and perform acceptable measurements, you will need the following
- At least one of those C compiler : `GCC`, `Clang`, `icc` et `icx`.
- `GNUPlot`
- `cpupower`
- `taskset`
- `cblas` or\and `mkl` (if `icc` ou `icx` is installed) libraries
- `bash`
- `make`

## Usage

*In order to have stable measures, please be sure you fixed your processor frequency using `cpupower` before running the script.*

The `perf.sh` is the only file you need to execute if you want to repeat the same experiment as the one presented in the report on your machine.
This script will handle the compilation and execution of the different programs with different compilation files.
Then, it will gather the output datas to create graphs using `GNUPlot`.

All the results of the execution of this script will be found in a `RESULTS` directory.

