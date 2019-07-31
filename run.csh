#!/bin/csh

  ############################################                                                      
  #                                          #                                                          
  #      GREB-GCR -> script run.csh          #                                                     
  #                                          #                                                     
  #  Author: Emerson D. Oliveira - 29/07/19  #                                                     
  ############################################                                                     
                                                                                                   
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

###################################################################################################
#                      SUMMARY OF THE MAIN EXPERIMENTS OF THE GREB-GCR MODEL                      #
#                                                                                                 # 
#            ________________________________________________________________________             #
# EXP -> 10 | Simulates all processes of the global energy balance of the GREB model |            #
#           |, adopting 2xCO2. Editable variable: ctr_co2                            |            #
#           |________________________________________________________________________|            #
#            ________________________________________________________________________             #
# EXP -> 12 | Simulates all processes of the global energy balance of the GREB model |            #
#           |, adopting an observed series of CO2 valid only between the years       |            #
#           | [1700-2017].                                                           |            #
#           |________________________________________________________________________|            #
#            _____________________________________________________________________________        #
# EXP -> 19 | Simulates all processes of the global energy balance of the GREB model      |       #
#           |, parametrization of the effects of the Galactic Cosmic Rays on global cloud |       #
#           | coverage, disturbing shortwave radiation and atmospheric emissivity as      |       #
#           | a function of the number of sunspots. It is valid only between the          |       #  
#           | years of [1700-2017]. Editable variable: vcld                               |       #
#           |_____________________________________________________________________________|       #
#            ______________________________________________________________________________       #
# EXP -> 20 | Simulates the CO2 variation and the GCR theory simultaneously, that is, the  |      #    
#           | experiments EXP12 and EXP19. Being valid only between the years of           |      #
#           | [1700-2018] years of [1700-2017]. Editable variable: vcld                    |      #                                 
#           |______________________________________________________________________________|      #
#                                                                                                 #
###################################################################################################


# Namelist
cat >namelist <<EOF
&NUMERICS
time_flux = $tflux    ! length of flux corrections run [yrs]
time_ctrl = $tctrl    ! length of control run [yrs]
time_scnr = $tscnr    ! length of scenariorun [yrs]
name_exp  = "$name"   ! Choice an name for output run;
var_co2   = $ctr_co2  ! CO2 Control [ppm]
init_yr   = $ini_yr   ! starter year
ctrl_yr   = $ctr_yr   ! control year
/
&PHYSICS
log_exp   = $exp      ! complete GREB model; 2xCO2 forcing
var_cloud = $vcld,    ! variability cloud cover [%]; 
max_sn    = 269.3,    ! maximum sunspot number;
/
EOF
mv namelist exec/

# Output Directory
set DIR   =  $PWD         # Current Directory 
mkdir $DIR/output/$name

# experiments run
set yri=$ini_yr
set yrf = `expr $yri + $tscnr - 1`

   if ( "$exp" == "10" || "$exp" == "12" || "$exp" == "17" || "$exp" == "18" || "$exp" == "19" || "$exp" == "20" ) then

     if ( "$ini_yr" >= "1700" && "$ini_yr" <= "2017" ) then 

       echo ""
       echo ""
       echo " ************************* RUNNING EXPERIMENT [$ini_yr-$yrf] ****************************"
       echo ""
       cd $DIR/exec
       echo " % Threads: $nproc"
       echo " -------------------------------------------------------------------------------------" 
       limit stacksize unlimited  
       setenv OMP_NUM_THREADS $nproc 
       /usr/bin/time -p ./greb.x
       echo " ******************************** FINISHING ******************************************"

     else 

       echo " **** ERROR **** -> Adopt the starting year between 1700 and 2017"

     endif

   else

       echo " **** ERROR **** -> Incorrect experiment number, valid options: 10, 12, 17, 18, 19, or 20"

  endif




