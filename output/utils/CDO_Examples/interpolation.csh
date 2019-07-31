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

# Interpoling scenario[96x48] to scenario_[NXxNY].nc
cdo remapbil,r200x100 scenario.nc scenario_200x100.nc

#
# For more examples visit https://code.mpimet.mpg.de/projects/cdo/wiki/Tutorial
#

