!+++++++++++++++++++++++++++++++++++++++
subroutine greb_model
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/02/2019

!   climate model main loop

  use mo_numerics
  use mo_physics
  use mo_diagnostics
 
! declare temporary fields
  real, dimension(xdim,ydim) :: Ts0, Ts1, Ta0, Ta1, To0, To1, q0, q1,       &
&                               ts_ini, ta_ini, q_ini, to_ini       
  integer :: ntime

!  call execute_command_line (' mkdir -p ../output/'// trim(name_exp)//'')

  open(21,file='../output/'//trim(name_exp)//'/'//'control',ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(22,file='../output/'//trim(name_exp)//'/'//'scenario',ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)

  ntime = 12*time_scnr
! write file descriptor scenario.ctl  
  open(25,file='../output/'//trim(name_exp)//'/'//'scenario.ctl',FORM='FORMATTED',ACTION='WRITE',STATUS='UNKNOWN')
  write(25,'(A14                  )')'DSET ^scenario'
  write(25,'(A1                   )')'*'
  write(25,'(A13                  )')'*OPTIONS YREV'
  write(25,'(A1                   )')'*'
  write(25,'(A17                  )')'UNDEF -0.1000E+06' 
  write(25,'(A1                   )')'*'
  write(25,'(A15                  )')'TITLE GREG-GCR'
  write(25,'(A1                   )')'*'
  write(25,'(A38                  )')'XDEF   96 LINEAR     0.0000    3.75000'
  write(25,'(A38                  )')'YDEF   48 LINEAR   -88.12500   3.75000'
  write(25,'(A21                  )')'ZDEF    1 LEVELS 1000'
  write(25,'(A5,I6,A12,I4,A5      )')'TDEF ',ntime,' LINEAR  JAN',init_yr,' 1mo'
  write(25,'(A6                   )')'VARS 7'
  write(25,'(A44                  )')'tmm    0 99 Surface    Temperature  [K]     '
  write(25,'(A44                  )')'tamm   0 99 Atmosphere Temperature  [K]     '
  write(25,'(A44                  )')'tomm   0 99 deep ocean temperature  [K]     '
  write(25,'(A44                  )')'qmm    0 99 air water vapor         [kg/kg] '
  write(25,'(A44                  )')'apmm   0 99 Albedo                  [%]     '
  write(25,'(A44                  )')'qlmm   0 99 Latent Heat             [W/m^2] '
  write(25,'(A44                  )')'qsmm   0 99 Sensible Heat           [W/m^2] '
  write(25,'(A7                   )')'ENDVARS'
  close(25,STATUS='KEEP')

! write file descriptor control.ctl  
  open(27,file='../output/'//trim(name_exp)//'/'//'control.ctl',FORM='FORMATTED',ACTION='WRITE',STATUS='UNKNOWN')
  write(27,'(A14                  )')'DSET ^control'
  write(27,'(A1                   )')'*'
  write(27,'(A13                  )')'*OPTIONS YREV'
  write(27,'(A1                   )')'*'
  write(27,'(A17                  )')'UNDEF -0.1000E+06' 
  write(27,'(A1                   )')'*'
  write(27,'(A15                  )')'TITLE GREG-GCR'
  write(27,'(A1                   )')'*'
  write(27,'(A38                  )')'XDEF   96 LINEAR     0.0000    3.75000'
  write(27,'(A38                  )')'YDEF   48 LINEAR   -88.12500   3.75000'
  write(27,'(A21                  )')'ZDEF    1 LEVELS 1000'
  write(27,'(A21,I4,A5            )')'TDEF   12 LINEAR  JAN',ctrl_yr,'  1mo'
  write(27,'(A6                   )')'VARS 7'
  write(27,'(A44                  )')'tmm    0 99 Surface    Temperature  [K]     '
  write(27,'(A44                  )')'tamm   0 99 Atmosphere Temperature  [K]     '
  write(27,'(A44                  )')'tomm   0 99 deep ocean temperature  [K]     '
  write(27,'(A44                  )')'qmm    0 99 air water vapor         [kg/kg] '
  write(27,'(A44                  )')'apmm   0 99 Albedo                  [%]     '
  write(27,'(A44                  )')'qlmm   0 99 Latent Heat             [W/m^2] '
  write(27,'(A44                  )')'qsmm   0 99 Sensible Heat           [W/m^2] '
  write(27,'(A7                   )')'ENDVARS'
  close(27,STATUS='KEEP')


  dTrad = -0.16*Tclim -5. ! offset Tatmos-rad

! set ocean depth
  z_ocean=0
  do i=1,nstep_yr
     where(mldclim(:,:,i).gt.z_ocean) z_ocean = mldclim(:,:,i)
  end do
  z_ocean = 3.0*z_ocean

  if (log_exp ==  1) where(z_topo > 1.) z_topo = 1.0      ! sens. exp. constant topo
  if (log_exp <=  2) cldclim = 0.7                        ! sens. exp. constant cloud cover
  if (log_exp <=  3) qclim   = 0.0052                     ! sens. exp. constant water vapor
  if (log_exp <=  9) mldclim = d_ocean                    ! sens. exp. no deep ocean
  if (log_exp == 11) mldclim = d_ocean                    ! sens. exp. no deep ocean

! heat capacity global [J/K/m^2]
  where (z_topo  > 0.) cap_surf = cap_land
  where (z_topo <= 0.) cap_surf = cap_ocean*mldclim(:,:,1)

! initialize fields
  Ts_ini   = Tclim(:,:,nstep_yr)                          ! initial value temp. surf
  Ta_ini   = Ts_ini                                       ! initial value atm. temp.
  To_ini   = Toclim(:,:,nstep_yr)                         ! initial value temp. surf
  q_ini    = qclim(:,:,nstep_yr)                          ! initial value atmos water vapor

  CO2_ctrl = var_co2
  if (log_exp == 12 .or. log_exp == 13 ) CO2_ctrl = 280.  ! A1B scenario

  ! define some program constants
  wz_air   = exp(-z_topo/z_air)
  wz_vapor = exp(-z_topo/z_vapor)
  where (uclim(:,:,:) >= 0.0) 
     uclim_m = uclim
     uclim_p = 0.0
  elsewhere
     uclim_m = 0.0
     uclim_p = uclim
  end where
  where (vclim(:,:,:) >= 0.0) 
     vclim_m = vclim
     vclim_p = 0.0
  elsewhere
     vclim_m = 0.0
     vclim_p = vclim
  end where
  
! compute Q-flux corrections
  print*,'% flux correction ', CO2_ctrl
  call qflux_correction(CO2_ctrl, Ts_ini, Ta_ini, q_ini, To_ini)

! test write qflux
  do irec=1, nstep_yr
     write(21,rec=irec)  TF_correct(:,:,irec)
  end do

! control run
  print*,'% CONTROL RUN CO2=',CO2_ctrl,'  time=', time_ctrl,'yr'
  Ts1 = Ts_ini; Ta1 = Ta_ini; To1 = To_ini; q1 = q_ini;                   ! initialize fields
  mon=1; year=ctrl_yr; irec=0; Tmm=0.; Tamm=0.; qmm=0.; apmm=0.;  
  do it=1, time_ctrl*nstep_yr                                             ! main time loop
     call time_loop(it, isrec, year, CO2_ctrl, irec, mon, 21, Ts1, Ta1, q1, To1, Ts0,Ta0, q0, To0 ) 
    Ts1=Ts0; Ta1=Ta0; q1=q0; To1=To0    
  end do

! scenario run
 print*,'% SCENARIO EXP: ',log_exp,'  time=', time_scnr,'yr'
  Ts1 = Ts_ini; Ta1 = Ta_ini; q1 = q_ini; To1 = To_ini                     ! initialize fields
  year=init_yr; CO2 = 280.; mon=1; irec=0; Tmm=0.; Tamm=0.; qmm=0.; apmm=0.; 
  do it=1, time_scnr*nstep_yr                                              ! main time loop
     call co2_level(it, year, CO2)

     ! sens. exp. SST+1
     if(log_exp >= 14 .and. log_exp <= 16) CO2 = CO2_ctrl
     if(log_exp >= 14 .and. log_exp <= 16) where (z_topo < 0.0) Ts1 = Tclim(:,:,ityr)+1.0 

     call time_loop(it,isrec, year, CO2, irec, mon, 22, Ts1, Ta1, q1, To1, Ts0,Ta0, q0, To0 ) 
     Ts1=Ts0; Ta1=Ta0; q1=q0; To1=To0      
     if (mod(it,nstep_yr) == 0) year=year+1
  end do
 !call execute_command_line ( ' cdo -f nc import_binary '// trim(outfldr)//'scenario.ctl ' // trim(outfldr)//'scenario.nc ' )
 !call execute_command_line ( ' rm '// trim(outfldr)//'scenario ' // trim(outfldr)//'scenario.ctl ' ) 

end subroutine greb_model
