# GREB-GCR-v.0.1

GREB-GCR Installation

Basic Requirements:

Install a Fortran Compiler
Install the Cshell Script Language
GREB-GCR is already configured to run with the gfortran compiler,
if you want to use another compiler, you must edit the Makefile file in the source folder.

Source code compilation:

Ubuntu operating system

Open a linux terminal
Use the shortcut: Ctrl + Alt + T
Type: ls
Hit the enter key
Your home folders are:

emerson@labmet:~$ ls
Desktop    Downloads         Music     Public   snap       Videos
Documents  examples.desktop  Pictures  Scripts  Templates
emerson@labmet:~$ 

Browse through the terminal to the directory where the GREB-GCR-v.0.1.zip file is located. 
In this example I left the file in the Desktop directory.

emerson@labmet:~$ cd Desktop/
emerson@labmet:~/Desktop$ ls
GREB-GCR-v.0.1.zip
emerson@labmet:~/Desktop$ 

Unzip the file: unzip GREB-GCR-v.0.1.zip

emerson@labmet:~/Desktop$ ls
GREB-GCR-v.0.1  GREB-GCR-v.0.1.zip
emerson@labmet:~/Desktop$ 

Enter the GREB-GCR Template Folder

emerson@labmet:~/Desktop$ cd GREB-GCR-v.0.1/
emerson@labmet:~/Desktop/GREB-GCR-v.0.1$ ls
exec  input  notes  output  run.csh  source
emerson@labmet:~/Desktop/GREB-GCR-v.0.1$ 

Enter the source directory

emerson@labmet:~/Desktop/GREB-GCR-v.0.1$ cd source/
emerson@labmet:~/Desktop/GREB-GCR-v.0.1/source$ ls
advection.f90    diffusion.f90        main.f90            output.f90
circulation.f90  flux_correction.f90  Makefile            seaice.f90
co2.f90          greb_model.f90       mo_diagnostics.f90  sw_radiation.f90
deep_ocean.f90   hydrological.f90     mo_numerics.f90     tendencies.f90
diagnostics.f90  lw_radiation.f90     mo_physics.f90      time_loop.f90
emerson@labmet:~/Desktop/GREB-GCR-v.0.1/source$ 

Build the model: make greb

emerson@labmet:~/Desktop/GREB-GCR-v.0.1/source$ make greb
gfortran -fopenmp            -c -O3  mo_numerics.f90
gfortran -fopenmp            -c -O3  mo_physics.f90
gfortran -fopenmp            -c -O3  mo_diagnostics.f90
gfortran -fopenmp            -c -O3  sw_radiation.f90
gfortran -fopenmp            -c -O3  lw_radiation.f90
gfortran -fopenmp            -c -O3  hydrological.f90
gfortran -fopenmp            -c -O3  seaice.f90
gfortran -fopenmp            -c -O3  deep_ocean.f90
gfortran -fopenmp            -c -O3  co2.f90
gfortran -fopenmp            -c -O3  advection.f90
gfortran -fopenmp            -c -O3  diffusion.f90
gfortran -fopenmp            -c -O3  circulation.f90
gfortran -fopenmp            -c -O3  tendencies.f90
gfortran -fopenmp            -c -O3  output.f90
gfortran -fopenmp            -c -O3  diagnostics.f90
gfortran -fopenmp            -c -O3  time_loop.f90
gfortran -fopenmp            -c -O3  flux_correction.f90
gfortran -fopenmp            -c -O3  greb_model.f90
gfortran -fopenmp            -c -O3  main.f90
gfortran -fopenmp            -o ../exec/greb.x mo_numerics.o mo_physics.o mo_diagnostics.o 
sw_radiation.o lw_radiation.o hydrological.o seaice.o deep_ocean.o co2.o advection.o diffusion.o 
circulation.o tendencies.o time_loop.o flux_correction.o greb_model.o diagnostics.o output.o main.o 
emerson@labmet:~/Desktop/GREB-GCR-v.0.1/source$ 

When the compilation is finished an executable file "greb.x" is generated in the exec folder. 
If everything is correct, CONGRATULATIONS the GREB-GCR template is already installed.

Now edit the namelist of the run.csh file

###### Setting the namelist #########

set ini_yr  =  1940      # Starter Year 

set ctr_yr  =  1970      # Control Year [Fix year] 
set ctr_co2 =  340       # Control CO2 value [ppm]

set tflux   =  10        # Fluxe Corrections [years]
set tctrl   =  10        # Control Experiments [years]
set tscnr   =  10        # Total Years Simulation [years]
 
set exp     =  20        # Choice experiment number
set name    =  EXP20     # Output directory name
set vcld    =  0.01      # Cloud cover variation [%]
set nproc   =  2         # Threads number [1 or 2]

######################################

Ready, type in the ./run.csh terminal and the model will start the simulation.

Good luck,
Emerson D. Oliveira





