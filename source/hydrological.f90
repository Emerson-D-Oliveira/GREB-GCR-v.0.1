!+++++++++++++++++++++++++++++++++++++++
subroutine hydro(Tsurf, q, Qlat, Qlat_air, dq_eva, dq_rain)
!+++++++++++++++++++++++++++++++++++++++
!    hydrological model for latent heat and water vapor

  USE mo_numerics,    ONLY: xdim, ydim
  USE mo_physics,     ONLY: rho_air, uclim, vclim, z_topo, swetclim, ityr,   &
&                           ce, cq_latent, cq_rain, z_air, r_qviwv, log_exp

! declare temporary fields
  real, dimension(xdim,ydim)  :: Tsurf, q, Qlat, Qlat_air, qs, dq_eva,        &
&                                dq_rain, abswind

  Qlat=0.; Qlat_air=0.; dq_eva=0.; dq_rain=0.
  if(log_exp <=  6 .or. log_exp == 13 .or. log_exp == 15) return

  abswind = sqrt(uclim(:,:,ityr)**2 +vclim(:,:,ityr)**2) 
  where(z_topo > 0. ) abswind = sqrt(abswind**2 +2.0**2) ! land
  where(z_topo < 0. ) abswind = sqrt(abswind**2 +3.0**2) ! ocean

! saturated humiditiy (max. air water vapor)
  qs = 3.75e-3*exp(17.08085*(Tsurf-273.15)/(Tsurf-273.15+234.175));
  qs = qs*exp(-z_topo/z_air) ! scale qs by topography
! latent heat flux surface
  Qlat    = (q-qs)*abswind*cq_latent*rho_air*ce*swetclim(:,:,ityr) 

! change in water vapor
  dq_eva  = -Qlat/cq_latent/r_qviwv  ! evaporation
  dq_rain = cq_rain*q                ! rain

! latent heat flux atmos
  Qlat_air = -dq_rain*cq_latent*r_qviwv 

end subroutine hydro
