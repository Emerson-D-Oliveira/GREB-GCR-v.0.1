!+++++++++++++++++++++++++++++++++++++++
subroutine time_loop(it, isrec, year, CO2, irec, mon, ionum, Ts1, Ta1, q1, To1, Ts0,Ta0, q0, To0)
!+++++++++++++++++++++++++++++++++++++++
! main time loop

! Modified by Emerson D. Oliveira - 10/10/2017

  use mo_numerics
  use mo_physics

  real, dimension(xdim,ydim):: Ts1, Ta1, q1, To1, Ts0,Ta0, q0, To0, sw,       &
&                              albedo, Q_sens, Q_lat, Q_lat_air, dq_eva,      &
&                              dq_rain, dTa_crcl, dq_crcl, dq, dT_ocean, dTo, &
&                              LW_surf, LWair_down, LWair_up, em

  jday = mod((it-1)/ndt_days,ndays_yr)+1  ! current calendar day in year
  ityr = mod((it-1),nstep_yr)+1           ! time step in year
    yr = ((it - 1)/nstep_yr) + 1          ! time in years

  call tendencies(CO2, Ts1, Ta1, To1, q1, albedo, SW, LW_surf, Q_lat,   &
&                    Q_sens, Q_lat_air, dq_eva, dq_rain, dq_crcl,       &
&                    dTa_crcl, dT_ocean, dTo, LWair_down, LWair_up, em)
  ! surface temperature
  Ts0  = Ts1  +dT_ocean +dt*( SW +LW_surf -LWair_down +Q_lat +Q_sens +TF_correct(:,:,ityr)) / cap_surf 
  ! air temperature
  Ta0  = Ta1 +dTa_crcl +dt*( LWair_up +LWair_down -em*LW_surf +Q_lat_air -Q_sens )/cap_air
  ! deep ocean temperature
  To0  = To1 +dTo +ToF_correct(:,:,ityr)
  ! air water vapor
  dq = dt*(dq_eva+dq_rain) +dq_crcl + qF_correct(:,:,ityr)
  where(dq .le. -q1 ) dq = -0.9*q1 ! no negative q;  numerical stability
  q0 = q1 + dq
  ! sea ice heat capacity
  call seaice(Ts0)
  ! write output
  call output(it, ionum, irec, mon, ts0, ta0, to0, q0, albedo, q_lat, q_sens)
  ! diagnostics: annual means plots
  call diagonstics(it, year, CO2, ts0, ta0, to0, q0, albedo, sw, lw_surf, q_lat, q_sens)

end subroutine time_loop
