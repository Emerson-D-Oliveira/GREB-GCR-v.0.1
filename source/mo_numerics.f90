! 
!----------------------------------------------------------
!   The Globally Resolved Energy Balance (GREB) Model 
!----------------------------------------------------------
! 
!   Authors; Dietmar Dommenget and Janine Flöter 
!            with numerical opitmizations by Micheal Rezny
! 
!            This version was builded by Emerson D. Oliveira 
!            Last modified in 05/02/2019
!-----------------------------------------------------------------------
!   Global Resolved Energy Balance - Galactic Cosmic Rays (GREB-GCR)
!-----------------------------------------------------------------------
! 
!  input fields: The GREB-GCR model needs the following fields to be specified before 
!                the main subroutine greb_model is called:
! 
!  z_topo(xdim,ydim):             topography (<0 are ocean points) [m]
!  glacier(xdim,ydim):            glacier mask ( >0.5 are glacier points )
!  Tclim(xdim,ydim,nstep_yr):     mean Tsurf                       [K]
!  uclim(xdim,ydim,nstep_yr):     mean zonal wind speed            [m/s]
!  vclim(xdim,ydim,nstep_yr):     mean meridional wind speed       [m/s]
!  qclim(xdim,ydim,nstep_yr):     mean atmospheric humidity        [kg/kg]
!  mldclim(xdim,ydim,nstep_yr):   mean ocean mixed layer depth     [m]
!  Toclim(xdim,ydim,nstep_yr):    mean deep ocean temperature      [K]
!  swetclim(xdim,ydim,nstep_yr):  soil wetnees, fraction of total  [0-1]
!  sw_solar(ydim,nstep_yr):       24hrs mean solar radiation       [W/m^2]              
!  co2(time_yr):                  mean anual of CO2 concentration [ppm] 
!  sn(time_yr):                   mean anual of number sunspots    []     
!+++++++++++++++++++++++++++++++++++++++
module mo_numerics
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/07/2017

! numerical parameter
  integer, parameter :: xdim = 96, ydim = 48          ! field dimensions
  integer, parameter :: ndays_yr  = 365               ! number of days per year
  integer, parameter :: dt        = 12*3600           ! time step [s]
  integer, parameter :: dt_crcl   = 0.5*3600          ! time step circulation [s]  
  integer, parameter :: ndt_days  = 24*3600/dt        ! number of timesteps per day
  integer, parameter :: nstep_yr  = ndays_yr*ndt_days ! number of timesteps per year  
  integer, parameter :: time_yr   = 318               ! time year as parameter 316       
  integer            :: time_flux = 0                 ! length of integration for flux correction [yrs]
  integer            :: time_ctrl = 0                 ! length of integration for control run  [yrs]
  integer            :: time_scnr = 0                 ! length of integration for scenario run [yrs]
  integer            :: ipx       = 1                 ! points for diagonstic print outs
  integer            :: ipy       = 1                 ! points for diagonstic print outs
  integer, parameter, dimension(12) :: jday_mon = (/31,28,31,30,31,30,31,31,30,31,30,31/) ! days per 
  real, parameter    :: dlon      = 360./xdim         ! linear increment in lon
  real, parameter    :: dlat      = 180./ydim         ! linear increment in lat
  integer            :: ireal     = 4                 ! record length for IO (machine dependent)
  character(len=14)  :: name_exp                      ! name output directory
  integer            :: var_co2   = 0                 ! co2 concentration
  integer            :: init_yr   = 0                 ! initial year
  integer            :: ctrl_yr   = 0                 ! control year

! 												ireal = 4 for Mac Book Pro 
  namelist / numerics / time_flux, time_ctrl, time_scnr, name_exp, var_co2, init_yr, ctrl_yr
  

end module mo_numerics
