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

# Extract tsurf variable from scenario.nc
cdo select,name=tmm scenario.nc tsurf.nc

#
# For more examples visit https://code.mpimet.mpg.de/projects/cdo/wiki/Tutorial
#

