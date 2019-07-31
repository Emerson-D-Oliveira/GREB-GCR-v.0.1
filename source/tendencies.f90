!+++++++++++++++++++++++++++++++++++++++
subroutine tendencies(CO2, Ts1, Ta1, To1, q1, albedo, SW, LW_surf, Q_lat, Q_sens, Q_lat_air, dq_eva,   & 
&                     dq_rain, dq_crcl, dTa_crcl, dT_ocean, dTo, LWair_down, LWair_up, em)
!+++++++++++++++++++++++++++++++++++++++

  use mo_numerics
  use mo_physics

! declare temporary fields
  real, dimension(xdim,ydim) :: Ts1, Ta1, To1, q1, albedo, sw, LWair_up,       &
&                               LWair_down, em, Q_sens, Q_lat, Q_lat_air,      &
&                               dq_eva, dq_rain, dTa_crcl, dq_crcl, LW_surf,   &
&                               dT_ocean, dTo

    ! SW radiation model
    call SWradiation(Ts1, sw, albedo)
    ! LW radiation model
    call LWradiation(Ts1, Ta1, q1, CO2, LW_surf, LWair_up, LWair_down, em) 
    ! sensible heat flux
    Q_sens = ct_sens*(Ta1-Ts1)
    ! hydro. model
    call hydro(Ts1, q1, Q_lat, Q_lat_air, dq_eva, dq_rain)
    ! atmos. circulation
!$omp parallel sections
!$omp section
    call circulation(Ta1, dTa_crcl, z_air, wz_air)       ! air temp 
!$omp section
    call circulation( q1,  dq_crcl, z_vapor, wz_vapor)   ! atmos water vapor
!$omp end parallel sections
    ! deep ocean interaction
    call deep_ocean(Ts1, To1, dT_ocean, dTo)

end subroutine tendencies
