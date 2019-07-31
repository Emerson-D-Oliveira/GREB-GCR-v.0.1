#/bin/csh


##########################################
#                                        #
#     GREB-GCR -> Examples with CDO      #
#                                        #
# Author: Emerson D. Oliveira - 29/12/17 #
#                                        #
##########################################

#
# CLIMATE DATA OPERATOR (CDO)
#

# Converting to netcdf
cdo -f nc import_binary scenario.ctl scenario.nc

# Converting from monthly averages to annual averages
cdo yearmean scenario.nc scenario_annual.nc 

# Interpoling scenario[96x48] to scenario[200x100]
cdo remapbil,r200x100 scenario.nc scenario_200x100.nc

# Extract tsurf variable from scenario.nc
cdo select,name=tmm scenario.nc tsurf.nc

#
# For more examples visit https://code.mpimet.mpg.de/projects/cdo/wiki/Tutorial
#

