# GREB-GCR-v.0.1

GREB-GCR Installation

Basic Requirements:

Install a Fortran Compiler,
Install the Cshell Script Language,

GREB-GCR is already configured to run with the gfortran compiler,
if you want to use another compiler, you must edit the Makefile in the source folder.

Source code compilation:

Ubuntu operating system

Browse through the terminal to the directory where the GREB-GCR-v.0.1.zip file is located. 

Unzip the file: unzip GREB-GCR-v.0.1.zip

Enter the GREB-GCR Template Folder

Enter the source directory

Build the model: make greb

When the compilation is finished an executable file "greb.x" is generated in the exec folder. 
If everything is correct, CONGRATULATIONS the GREB-GCR was installed.

Now edit the namelist of the run.csh file

WARNING!!! -> run.csh file requires permission to run, type in terminal "chmod 777 run.csh"

Ready, type in the ./run.csh terminal and the model will start the simulation.

Good luck,

Emerson D. Oliveira





