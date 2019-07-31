.SUFFIXES: .f .F .f90 .f90 .o .mod
.SHELL: /bin/sh

.PHONY : usage

##################################
#                                #
# Author: Emerson D. Oliveira    #
#                                #
# Date:10/10/2017                #  
##################################


usage:
	@echo ""
	@echo "    * USAGE * "
	@echo ""	  
	@echo " make greb      : compile the main program model.x"
	@echo " make clean     : clean object files"
	@echo " make"																
                   

# Set fortran compiler 
 FC      = gfortran -fopenmp           
 FLAGS   = -I$(objdir) -J$(objdir)
 LFLAGS  = 
 DFLAGS  = -O3 


# Executable
EXEC=../exec/greb.x

OBJ= \
	mo_numerics.o \
	mo_physics.o \
	mo_diagnostics.o \
	sw_radiation.o \
	lw_radiation.o \
	hydrological.o \
	seaice.o \
	deep_ocean.o \
	co2.o \
	advection.o \
	diffusion.o \
	circulation.o \
	tendencies.o \
	time_loop.o \
	flux_correction.o \
	greb_model.o \
	diagnostics.o \
	output.o \
	main.o

greb: $(OBJ)
	$(FC) -o $(EXEC) $(OBJ) 

mo_numerics.o : mo_numerics.f90
	$(FC) -c $(DFLAGS) mo_numerics.f90

mo_physics.o : mo_physics.f90  mo_numerics.o
	$(FC) -c $(DFLAGS) mo_physics.f90

mo_diagnostics.o : mo_diagnostics.f90 mo_numerics.o
	$(FC) -c $(DFLAGS) mo_diagnostics.f90

sw_radiation.o : sw_radiation.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) sw_radiation.f90

lw_radiation.o : lw_radiation.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) lw_radiation.f90

hydrological.o : hydrological.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) hydrological.f90

seaice.o : seaice.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) seaice.f90

deep_ocean.o : deep_ocean.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) deep_ocean.f90

co2.o : co2.f90 mo_numerics.o mo_physics.o
	$(FC) -c $(DFLAGS) co2.f90

advection.o : advection.f90 mo_numerics.o mo_physics.o 
	$(FC) -c $(DFLAGS) advection.f90

diffusion.o : diffusion.f90 mo_numerics.o mo_physics.o 
	$(FC) -c $(DFLAGS) diffusion.f90

circulation.o : circulation.f90 mo_numerics.o mo_physics.o  advection.o diffusion.o
	$(FC) -c $(DFLAGS) circulation.f90

tendencies.o : tendencies.f90 mo_numerics.o mo_physics.o sw_radiation.o lw_radiation.o \
		hydrological.o deep_ocean.o circulation.o 
	$(FC) -c $(DFLAGS) tendencies.f90

time_loop.o : time_loop.f90 mo_numerics.o mo_physics.o tendencies.o seaice.o \
		output.o diagnostics.o 
	$(FC) -c $(DFLAGS) time_loop.f90

flux_correction.o : flux_correction.f90 mo_numerics.o mo_physics.o tendencies.o seaice.o \
		diagnostics.o 
	$(FC) -c $(DFLAGS) flux_correction.f90

greb_model.o : greb_model.f90 mo_numerics.o mo_physics.o  time_loop.o \
		co2.o flux_correction.o 
	$(FC) -c $(DFLAGS) greb_model.f90

diagnostics.o : diagnostics.f90 mo_numerics.o mo_physics.o mo_diagnostics.o
	$(FC) -c $(DFLAGS) diagnostics.f90

output.o : output.f90 mo_numerics.o mo_physics.o mo_diagnostics.o
	$(FC) -c $(DFLAGS) output.f90

main.o : main.f90 mo_numerics.o mo_physics.o greb_model.o
	$(FC) -c $(DFLAGS) main.f90


clean:
	@echo ""	
	@echo " ******* Clear files .o .mod *******"
	@echo ""
	rm -f ../exec/greb.x *.o *.mod 
	@echo ""
	@echo " ******* Finishing *******"
	@echo "" 
	
