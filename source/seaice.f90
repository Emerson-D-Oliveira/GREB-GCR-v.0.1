!+++++++++++++++++++++++++++++++++++++++
subroutine seaice(Tsurf)
!+++++++++++++++++++++++++++++++++++++++
!              SW radiation model

  USE mo_numerics,    ONLY: xdim, ydim
  USE mo_physics,     ONLY: ityr, z_topo, cap_surf, cap_land, cap_ocean, &
&                           log_exp, To_ice1, To_ice2, glacier, mldclim

! declare temporary fields
  real, dimension(xdim,ydim)  :: Tsurf

  where(z_topo < 0. .and. Tsurf <= To_ice1) cap_surf = cap_land                    ! sea ice
  where(z_topo < 0. .and. Tsurf >= To_ice2) cap_surf = cap_ocean*mldclim(:,:,ityr) ! open ocean
  where(z_topo < 0. .and. Tsurf > To_ice1 .and. Tsurf < To_ice2 ) &
&       cap_surf = cap_land + (cap_ocean*mldclim(:,:,ityr)-cap_land)     &
&                            /(To_ice2-To_ice1)*(Tsurf-To_ice1)

  if( log_exp <= 5 ) then
     where(z_topo > 0. ) cap_surf = cap_land                     ! sea ice
     where(z_topo < 0. ) cap_surf = cap_ocean*mldclim(:,:,ityr)  ! open ocean 
  end if

! glacier -> no sea ice change
  where(glacier > 0.5) cap_surf = cap_land                       ! ice sheet

end subroutine seaice
