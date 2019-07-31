# GREB-GCR-v.0.1

GREB-GCR Installation

Basic Requirements:

Install a Fortran Compiler,
Install the Cshell Script Language,

GREB-GCR is already configured to run with the gfortran compiler,
if you want to use another compiler, you must edit the Makefile file in the source folder.

Source code compilation:

Ubuntu operating system

Browse through the terminal to the directory where the GREB-GCR-v.0.1.zip file is located. 
In this example I left the file in the Desktop directory.

Unzip the file: unzip GREB-GCR-v.0.1.zip

Enter the GREB-GCR Template Folder

Enter the source directory

Build the model: make greb

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





