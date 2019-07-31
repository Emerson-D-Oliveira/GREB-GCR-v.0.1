!+++++++++++++++++++++++++++++++++++++++
subroutine deep_ocean(Ts, To, dT_ocean, dTo)
!+++++++++++++++++++++++++++++++++++++++
!              deep ocean model

  USE mo_numerics,    ONLY: xdim, ydim, nstep_yr, dt 
  USE mo_physics,     ONLY: ityr, z_topo, mldclim, log_exp, To_ice2,     &
&                           cap_ocean, co_turb, z_ocean

! declare temporary fields
  real, dimension(xdim,ydim)  :: Ts, To, dT_ocean, dTo, dmld, Tx
  dT_ocean = 0.0;  dTo     = 0.0
  if ( log_exp <= 9 .or. log_exp == 11 )   return
  if ( log_exp >= 14 .and. log_exp <= 16 ) return

  if (ityr >  1) dmld = mldclim(:,:,ityr)-mldclim(:,:,ityr-1)
  if (ityr == 1) dmld = mldclim(:,:,ityr)-mldclim(:,:,nstep_yr)

! entrainment & detrainment
  where ( z_topo < 0 .and. Ts >= To_ice2 .and. dmld < 0)     &
&       dTo      = -dmld/(z_ocean-mldclim(:,:,ityr))*(Ts-To)
  where ( z_topo < 0 .and. Ts >= To_ice2 .and. dmld > 0)     &
&       dT_ocean =  dmld/mldclim(:,:,ityr)*(To-Ts)

 c_effmix = 0.5
 dTo      = c_effmix*dTo
 dT_ocean = c_effmix*dT_ocean 

! turbulent mixing
  Tx = max(To_ice2,Ts)   
  dTo      = dTo      + dt*co_turb*(Tx-To)/(cap_ocean*(z_ocean-mldclim(:,:,ityr)))
  dT_ocean = dT_ocean + dt*co_turb*(To-Tx)/(cap_ocean*mldclim(:,:,ityr)) 

end subroutine deep_ocean
