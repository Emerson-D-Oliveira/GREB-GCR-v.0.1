!+++++++++++++++++++++++++++++++++++++++
subroutine output(it, iunit, irec, mon, ts0, ta0, to0, q0, albedo, q_lat, q_sens)
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 10/10/2017

!    write output

  USE mo_numerics,     ONLY: xdim, ydim, jday_mon, ndt_days
  USE mo_physics,      ONLY: jday
  use mo_diagnostics,  ONLY: Tmm, Tamm, Tomm, qmm, apmm, qlatmm, qsensmm
 
  ! declare temporary fields
  real, dimension(xdim,ydim)  :: Ts0, Ta0, To0, q0, albedo, q_sens, q_lat

  ! diagnostics: monthly means
  Tmm=Tmm+Ts0; Tamm=Tamm+ta0; Tomm=Tomm+to0; qmm=qmm+q0; apmm=apmm+albedo; qlatmm=qlatmm+q_lat; qsensmm=qsensmm+q_sens
  if (       jday == sum(jday_mon(1:mon))                   &
&      .and. it/float(ndt_days) == nint(it/float(ndt_days)) ) then
     ndm=jday_mon(mon)*ndt_days
     irec=irec+1; write(iunit,rec=irec)  Tmm/ndm
     irec=irec+1; write(iunit,rec=irec)  Tamm/ndm
     irec=irec+1; write(iunit,rec=irec)  Tomm/ndm
     irec=irec+1; write(iunit,rec=irec)  qmm/ndm
     irec=irec+1; write(iunit,rec=irec)  apmm/ndm
     irec=irec+1; write(iunit,rec=irec)  qlatmm/ndm
     irec=irec+1; write(iunit,rec=irec)  qsensmm/ndm
     Tmm=0.; Tamm=0.;Tomm=0.; qmm=0.; apmm=0.; qlatmm=0.; qsensmm=0.;
     mon=mon+1; if (mon==13) mon=1
  end if

end subroutine output
