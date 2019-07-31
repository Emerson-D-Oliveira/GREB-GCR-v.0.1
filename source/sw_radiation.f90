!+++++++++++++++++++++++++++++++++++++++
subroutine SWradiation(Tsurf, sw, albedo)
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/02/2019

!    SW radiation model

  USE mo_numerics,    ONLY: xdim, ydim, init_yr
  USE mo_physics,     ONLY: ityr, sw_solar,da_ice, a_no_ice, a_cloud, var_cloud, max_sn, z_topo  &
&                         , Tl_ice1, Tl_ice2, To_ice1, To_ice2, glacier       &
&                         , cldclim, log_exp, sn, yr, pi

! declare temporary fields
  real, dimension(xdim,ydim)  :: Tsurf, sw, albedo, a_atmos, a_surf 
  
! atmos albedo
if ( log_exp .eq. 17 .or. log_exp .eq. 19 .or. log_exp .eq. 20 ) then
 a_atmos=(cldclim(:,:,ityr) + cldclim(:,:,ityr)*(cos((sn(yr+(init_yr-1700))/max_sn)*pi)*var_cloud))*a_cloud   ! atmospheric albedo second GCR theory
else
 a_atmos=cldclim(:,:,ityr)*a_cloud                                         ! atmospheric albedo
endif

! surface albedo
! Land:  ice -> albedo linear function of T_surf
   where(z_topo >= 0. .and. Tsurf <= Tl_ice1) a_surf = a_no_ice+da_ice     ! ice
   where(z_topo >= 0. .and. Tsurf >= Tl_ice2) a_surf = a_no_ice            ! no ice
   where(z_topo >= 0. .and. Tsurf > Tl_ice1 .and. Tsurf < Tl_ice2 ) &
&       a_surf = a_no_ice +da_ice*(1-(Tsurf-Tl_ice1)/(Tl_ice2-Tl_ice1))
! Ocean: ice -> albedo/heat capacity linear function of T_surf
  where(z_topo < 0. .and. Tsurf <= To_ice1) a_surf = a_no_ice+da_ice       ! ice
  where(z_topo < 0. .and. Tsurf >= To_ice2) a_surf = a_no_ice              ! no ice
  where(z_topo < 0. .and. Tsurf > To_ice1 .and. Tsurf < To_ice2 ) &
&       a_surf = a_no_ice+da_ice*(1-(Tsurf-To_ice1)/(To_ice2-To_ice1))

! glacier -> no albedo changes
  where(glacier > 0.5) a_surf = a_no_ice+da_ice

  if (log_exp <= 5) a_surf = a_no_ice

! SW flux
  albedo=a_surf+a_atmos-a_surf*a_atmos
  forall (i=1:xdim) 
     sw(i,:)=SW_solar(:,ityr)*(1-albedo(i,:)) 
  end forall

end subroutine SWradiation
