#!/bin/csh

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


# Extract tsurf variable from scenario_annual.nc
cdo select,name=tmm scenario_annual.nc tsurf.nc

#### Adopting land surface file for mask the oceans
cdo -f nc -setrtomiss,-20000,0 -topo topo_land.nc
cdo -f nc -remapcon,tsurf.nc topo_land.nc topo_land_grid_A.nc
cdo -f nc ifthen topo_land_grid_A.nc tsurf.nc tsurf_land.nc
rm topo_land.nc topo_land_grid_A.nc

#### Adopting the ocean file for mask the land surface
cdo -f nc -setrtomiss,0,10000 -topo topo_ocean.nc
cdo -f nc -remapcon,tsurf.nc topo_ocean.nc topo_ocean_grid_B.nc
cdo -f nc ifthen topo_ocean_grid_B.nc tsurf.nc tsurf_ocean.nc
rm topo_ocean.nc topo_ocean_grid_B.nc

#
# For more examples visit https://code.mpimet.mpg.de/projects/cdo/wiki/Tutorial
#

