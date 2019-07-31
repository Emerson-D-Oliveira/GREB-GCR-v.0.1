!+++++++++++++++++++++++++++++++++++++++
subroutine  qflux_correction(CO2_ctrl, Ts1, Ta1, q1, To1)
!+++++++++++++++++++++++++++++++++++++++
!              compute heat flux correction values

  USE mo_numerics
  USE mo_physics

! declare temporary fields
  real, dimension(xdim,ydim) :: Ts0, Ts1, Ta0, Ta1, To0, To1, q0, q1, sw, albedo,    &
&                               Q_sens, Q_lat, Q_lat_air, dq_eva, dq_rain, LW_surf,  &
&                               LWair_down, LWair_up, em, dTa_crcl, dq_crcl, dTs,    &
&                               dTa, dq, T_error, dT_ocean, dTo

! time loop
  do it=1, time_flux*ndt_days*ndays_yr
     jday = mod((it-1)/ndt_days,ndays_yr)+1  ! current calendar day in year
     ityr = mod((it-1),nstep_yr)+1           ! time step in year
       yr = ((it - 1)/nstep_yr) + 1          ! time in years

     call tendencies(CO2_ctrl, Ts1, Ta1, To1, q1, albedo, SW, LW_surf, Q_lat,  &
&                    Q_sens, Q_lat_air, dq_eva, dq_rain, dq_crcl, dTa_crcl,    &
&                    dT_ocean, dTo, LWair_down, LWair_up, em)

    ! surface temperature without heat flux correction
    dTs = dt*( sw +LW_surf -LWair_down +Q_lat +Q_sens) / cap_surf
    Ts0  = Ts1 +dTs +dT_ocean
    ! air temperature
    dTa = dt*( LWair_up +LWair_down -em*LW_surf +Q_lat_air -Q_sens)/cap_air
    Ta0  = Ta1 + dTa +dTa_crcl
    ! deep ocean temperature without heat flux correction
    To0  = To1 +dTo 
   ! air water vapor without flux correction
    dq = dt*(dq_eva+dq_rain) 
    q0 = q1 +dq +dq_crcl
   ! heat flux correction Tsurf
    T_error              = Tclim(:,:,ityr) -Ts0 ! error relative to Tclim
    TF_correct(:,:,ityr) = T_error*cap_surf/dt  ! heat flux in [W/m^2]
    ! surface temperature with heat flux correction
    Ts0  = Ts1 +dTs +dT_ocean +TF_correct(:,:,ityr)*dt/ cap_surf
   ! heat flux correction deep ocean
    ToF_correct(:,:,ityr) = Toclim(:,:,ityr) -To0  ! heat flux in [K/dt]
    ! deep ocean temperature with heat flux correction
    To0  = To1 +dTo +ToF_correct(:,:,ityr)
    ! water vapor flux correction
    qF_correct(:,:,ityr) = qclim(:,:,ityr) -q0
    ! air water vapor with flux correction
    q0 = q1 + dq +dq_crcl + qF_correct(:,:,ityr)
    ! sea ice heat capacity
    call seaice(Ts0)
    ! diagnostics: annual means plots
    call diagonstics(it, 0.0, CO2_ctrl, ts0, ta0, to0, q0, albedo, sw, lw_surf, q_lat, q_sens)
    ! memory
    Ts1=Ts0; Ta1=Ta0; q1=q0;  To1=To0; 
  end do

end subroutine qflux_correction
