!+++++++++++++++++++++++++++++++++++++++
subroutine diagonstics(it, year, CO2, ts0, ta0, to0, q0, albedo, sw, lw_surf, q_lat, q_sens)
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 10/10/2017

!    diagonstics plots

  USE mo_numerics,    ONLY: ndays_yr, xdim, ydim, ipx ,ipy, ndt_days, nstep_yr
  USE mo_physics,     ONLY: ityr, TF_correct, qF_correct, cap_surf, Tclim
  use mo_diagnostics

! declare temporary fields
  real, dimension(xdim,ydim)  :: Ts0, Ta0, To0, q0, sw, albedo, Q_sens, Q_lat,  LW_surf

  ! diagnostics: annual means
  tsmn=tsmn+Ts0; tamn=tamn+ta0; tomn=tomn+to0; qmn=qmn+q0; amn=amn+albedo
  swmn=swmn+sw;  lwmn=lwmn+LW_surf; qlatmn=qlatmn+q_lat; qsensmn=qsensmn+Q_sens;
  ftmn=ftmn+TF_correct(:,:,ityr); fqmn=fqmn+qF_correct(:,:,ityr);
  if ( ityr == nstep_yr ) then
     tsmn    = tsmn/nstep_yr;      tamn = tamn/nstep_yr;    tomn = tomn/nstep_yr;
     qmn     = qmn/nstep_yr;
     amn     = amn/nstep_yr;       swmn = swmn/nstep_yr;    lwmn = lwmn/nstep_yr;
     qlatmn  = qlatmn/nstep_yr; qsensmn = qsensmn/nstep_yr; ftmn = ftmn/nstep_yr;
     fqmn    = fqmn/nstep_yr;
     print *, year,"tsmn", tsmn(48-10,24-2)-273.15," qmn", qmn(48-10,24-2)*1000," amn ", amn(48-10,24-2)
     tsmn=0.; tamn=0.; qmn=0.; amn=0.; swmn=0.;        ! reset annual mean values
     lwmn=0.; qlatmn=0.; qsensmn=0.; ftmn=0.; fqmn=0.; ! reset annual mean values
  end if

end subroutine diagonstics
