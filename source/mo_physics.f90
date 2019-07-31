!+++++++++++++++++++++++++++++++++++++++
module mo_physics
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/02/2019

  use mo_numerics
  integer :: log_exp   = 0                 ! process control logics for sens. exp.  
  
! physical parameter (natural constants)
  parameter( pi        = 3.1416 )  
  parameter( sig       = 5.6704e-8 )     ! stefan-boltzmann constant [W/m^2/K^4]
  parameter( rho_ocean = 999.1 )         ! density of water at T=15C [kg/m^2]
  parameter( rho_land  = 2600. )         ! density of solid rock [kg/m^2]
  parameter( rho_air   = 1.2 )           ! density of air at 20C at NN 
  parameter( cp_ocean  = 4186. )         ! specific heat capacity of water at T=15C [J/kg/K]
  parameter( cp_land   = cp_ocean/4.5 )  ! specific heat capacity of dry land [J/kg/K]
  parameter( cp_air    = 1005. )         ! specific heat capacity of air      [J/kg/K]
  parameter( eps       = 1. )            ! emissivity for IR

! physical parameter (model values)
  parameter( d_ocean   = 50. )                     ! depth of ocean column [m]  
  parameter( d_land    = 2. )                      ! depth of land column  [m]
  parameter( d_air     = 5000. )                   ! depth of air column   [m]
  parameter( cap_ocean = cp_ocean*rho_ocean )      ! heat capacity 1m ocean  [J/K/m^2] 
  parameter( cap_land  = cp_land*rho_land*d_land ) ! heat capacity land   [J/K/m^2]
  parameter( cap_air   = cp_air*rho_air*d_air )    ! heat capacity air    [J/K/m^2]
  parameter( ct_sens   = 22.5 )                    ! coupling for sensible heat
  parameter( da_ice    = 0.25 )                    ! albedo diff for ice covered points
  parameter( a_no_ice  = 0.1 )                     ! albedo for non-ice covered points
  parameter( a_cloud   = 0.35 )                    ! albedo for clouds
  real    :: var_cloud = 0                         ! variability of clouds
  real    :: max_sn    = 0                         ! maximum sunspot number   
  parameter( Tl_ice1   = 273.15-10. )              ! temperature range of land snow-albedo feedback
  parameter( Tl_ice2   = 273.15  )                 ! temperature range of land snow-albedo feedback
  parameter( To_ice1   = 273.15-7. )               ! temperature range of ocean ice-albedo feedback
  parameter( To_ice2   = 273.15-1.7 )              ! temperature range of ocean ice-albedo feedback 
  parameter( co_turb   = 5.0 )                     ! turbolent mixing to deep ocean [W/K/m^2]
  parameter( kappa     = 8e5 )                     ! atmos. diffusion coefficient [m^2/s]
  parameter( ce        = 2e-3  )                   ! laten heat transfer coefficient for ocean
  parameter( cq_latent = 2.257e6 )                 ! latent heat of condensation/evapoartion f water [J/kg]
  parameter( cq_rain   = -0.1/24./3600. )          ! decrease in air water vapor due to rain [1/s]
  parameter( z_air     = 8400. )                   ! scaling height atmos. heat, CO2
  parameter( z_vapor   = 5000. )                   ! scaling height atmos. water vapor diffusion
  parameter( r_qviwv   = 2.6736e3)                 ! regres. factor between viwv and q_air  [kg/m^3] 

! parameter emissivity
  real, parameter, dimension(10) :: p_emi = (/9.0721, 106.7252, 61.5562, 0.0179, 0.0028,     &
&                                             0.0570, 0.3462, 2.3406, 0.7032, 1.0662/)

! declare climate fields
  real, dimension(xdim,ydim)          ::  z_topo, glacier,z_ocean
  real, dimension(xdim,ydim,nstep_yr) ::  Tclim, uclim, vclim, qclim, mldclim, Toclim, cldclim
  real, dimension(xdim,ydim,nstep_yr) ::  TF_correct, qF_correct, ToF_correct, swetclim, dTrad
  real, dimension(ydim,nstep_yr)      ::  sw_solar
  real, dimension(time_yr)            ::  sn, hco2

! declare constant fields
  real, dimension(xdim,ydim)          ::  cap_surf
  integer :: jday, ityr, yr

! declare some program constants
  real, dimension(xdim, ydim)         :: wz_air, wz_vapor
  real, dimension(xdim,ydim,nstep_yr) :: uclim_m, uclim_p 
  real, dimension(xdim,ydim,nstep_yr) :: vclim_m, vclim_p 

  real :: t0, t1, t2

  namelist / physics / log_exp, var_cloud, max_sn
  
end module mo_physics
