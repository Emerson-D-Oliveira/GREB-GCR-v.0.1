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

Ready, type in the ./run.csh terminal and the model will start the simulation.

Good luck,
Emerson D. Oliveira





