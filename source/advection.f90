!+++++++++++++++++++++++++++++++++++++++
subroutine advection(T1, dX_advec,h_scl, wz)
!+++++++++++++++++++++++++++++++++++++++
!    advection after DD

  USE mo_numerics, ONLY: xdim, ydim, dt, dlon, dlat, dt_crcl
  USE mo_physics,  ONLY: pi, z_topo, uclim, vclim, ityr, z_vapor, log_exp
  USE mo_physics,  ONLY: uclim_m, uclim_p, vclim_m, vclim_p
  implicit none

  real, dimension(xdim,ydim), intent(in)  :: T1, wz
  real                      , intent(in)  :: h_scl
  real, dimension(xdim,ydim), intent(out) :: dX_advec

  integer :: i
  integer, dimension(ydim):: ilat = (/(i,i=1,ydim)/)
  real, dimension(ydim) :: lat, dxlat, ccx
  real, dimension(xdim) :: T1h, dTxh
  real, dimension(xdim,ydim) :: ddx, T, dTx, dTy
  integer time2, dtdff2, tt2

  real    :: deg, dx, dy, dd, dyy, ccy, ccx2
  integer :: j, k, km1, km2, kp1, kp2, jm1, jm2, jm3, jp1, jp2, jp3
  
  deg = 2.*pi*6.371e6/360.;   ! length of 1deg latitude [m] 
  dx = dlon; dy=dlat; dyy=dy*deg
  lat = dlat*ilat-dlat/2.-90.;  dxlat=dx*deg*cos(2.*pi/360.*lat)
  ccy=dt_crcl/dyy/2.
  ccx=dt_crcl/dxlat/2.
  
     ! latitudinal   
     k=1
     kp1=k+1; kp2=k+2
     do j = 1, xdim
        dTy(j,k) = ccy * (                                                        &
&                     vclim_p(j,k,ityr)*( wz(j,kp1)*(T1(j,k)-T1(j,kp1))           &
&                                        +wz(j,kp2)*(T1(j,k)-T1(j,kp2)) ) )/3.
     end do
     k=2
     km1=k-1; kp1=k+1; kp2=k+2
     do j = 1, xdim
        dTy(j,k) = ccy * (                                                        &
&                    -vclim_m(j,k,ityr)*( wz(j,km1)*(T1(j,k)-T1(j,km1)))          &
&                   + vclim_p(j,k,ityr)*( wz(j,kp1)*(T1(j,k)-T1(j,kp1))           &
&                                        +wz(j,kp2)*(T1(j,k)-T1(j,kp2)) )/3. )
     end do
     do k=3, ydim-2
        km1=k-1; kp1=k+1; km2=k-2; kp2=k+2
        do j = 1, xdim
           dTy(j,k) = ccy * (                                                     &
&                       -vclim_m(j,k,ityr)*( wz(j,km1)*(T1(j,k)-T1(j,km1))        &
&                                           +wz(j,km2)*(T1(j,k)-T1(j,km2)) )      &
&                      + vclim_p(j,k,ityr)*( wz(j,kp1)*(T1(j,k)-T1(j,kp1))        &
&                                           +wz(j,kp2)*(T1(j,k)-T1(j,kp2)) ) )/3.
        end do
     end do
     k=ydim-1
     km1=k-1; kp1=k+1; km2=k-2
     do j = 1, xdim
        dTy(j,k) = ccy * (                                                        &
&                    -vclim_m(j,k,ityr)*( wz(j,km1)*(T1(j,k)-T1(j,km1))           &
&                                        +wz(j,km2)*(T1(j,k)-T1(j,km2)) )/3.      &
&                   + vclim_p(j,k,ityr)*( wz(j,kp1)*(T1(j,k)-T1(j,kp1)) ) )
     end do
     k=ydim
     km1=k-1; km2=k-2
     do j = 1, xdim
        dTy(j,k) = ccy * (                                                        &
&                    -vclim_m(j,k,ityr)*( wz(j,km1)*(T1(j,k)-T1(j,km1))           &
&                                        +wz(j,km2)*(T1(j,k)-T1(j,km2)) ) )/3.
     end do

     ! longitudinal
     do k=1, ydim
        if ( dxlat(k) > 2.5e5) then  ! unitl 25degree
           j = 1
           jm1 = xdim; jm2 = xdim-1; jp1 = j+1; jp2 = j+2
           dTx(j,k)= ccx(k) * (                                                      &
&                      -uclim_m(j,k,ityr)*( wz(jm1,k)*(T1(j,k)-T1(jm1,k))            &
&                                          +wz(jm2,k)*(T1(j,k)-T1(jm2,k)) )          &
&                     + uclim_p(j,k,ityr)*( wz(jp1,k)*(T1(j,k)-T1(jp1,k))            &
&                                          +wz(jp2,k)*(T1(j,k)-T1(jp2,k)) ) )/3.
           j = 2
           jm1 = j-1; jm2 = xdim; jp1 = j+1; jp2 = j+2
           dTx(j,k)= ccx(k) * (                                                      &
&                      -uclim_m(j,k,ityr)*( wz(jm1,k)*(T1(j,k)-T1(jm1,k))            &
&                                          +wz(jm2,k)*(T1(j,k)-T1(jm2,k)) )          &
&                     + uclim_p(j,k,ityr)*( wz(jp1,k)*(T1(j,k)-T1(jp1,k))            &
&                                          +wz(jp2,k)*(T1(j,k)-T1(jp2,k)) ) )/3.
           do j=3, xdim-2              ! longitudinal
                jm1=j-1; jp1=j+1; jm2=j-2; jp2=j+2
                dTx(j,k)= ccx(k) * (                                                  &
&                           -uclim_m(j,k,ityr)*( wz(jm1,k)*(T1(j,k)-T1(jm1,k))        &
&                                               +wz(jm2,k)*(T1(j,k)-T1(jm2,k)) )      &
&                          + uclim_p(j,k,ityr)*( wz(jp1,k)*(T1(j,k)-T1(jp1,k))        &
&                                               +wz(jp2,k)*(T1(j,k)-T1(jp2,k)) ) )/3.
           end do
           j = xdim-1
           jm1 = j-1; jm2 = j-2; jp1 = j+1; jp2 = 1
           dTx(j,k)= ccx(k) * (                                                      &
&                      -uclim_m(j,k,ityr)*( wz(jm1,k)*(T1(j,k)-T1(jm1,k))            &
&                                          +wz(jm2,k)*(T1(j,k)-T1(jm2,k)) )          &
&                     + uclim_p(j,k,ityr)*( wz(jp1,k)*(T1(j,k)-T1(jp1,k))            &
&                                          +wz(jp2,k)*(T1(j,k)-T1(jp2,k)) ) )/3.
           j = xdim
           jm1 = j-1; jm2 = j-2; jp1 = 1; jp2 = 2 
           dTx(j,k)= ccx(k) * (                                                      &
&                      -uclim_m(j,k,ityr)*( wz(jm1,k)*(T1(j,k)-T1(jm1,k))            &
&                                          +wz(jm2,k)*(T1(j,k)-T1(jm2,k)) )          &
&                     + uclim_p(j,k,ityr)*( wz(jp1,k)*(T1(j,k)-T1(jp1,k))            &
&                                          +wz(jp2,k)*(T1(j,k)-T1(jp2,k)) ) )/3.

        else  ! high resolution -> smaller time steps
            dd=max(1,nint(dt_crcl/(dxlat(k)/10.0/1.))); dtdff2=dt_crcl/dd
            time2=max(1,nint(float(dt_crcl)/float(dtdff2)))
            ccx2=dtdff2/dxlat(k)/2
            T1h=T1(:,k)
            do tt2=1, time2      ! additional time loop
                j = 1
                jm1=xdim; jm2=xdim-1; jm3=xdim-2; jp1=j+1; jp2=j+2; jp3=j+3
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                j = 2
                jm1=j-1; jm2=xdim; jm3=xdim-1; jp1=j+1; jp2=j+2; jp3=j+3
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                j = 3
                jm1=j-1; jm2=j-2; jm3=xdim; jp1=j+1; jp2=j+2; jp3=j+3
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                do j=4, xdim-3     ! longitudinal
                    jm1=j-1; jp1=j+1; jm2=j-2; jp2=j+2; jm3=j-3; jp3=j+3
                    dTxh(j)= ccx2 * (                                                          &
&                            -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )          &
&                                                 +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )          & 
&                                                 +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )        &
&                           + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )          &
&                                                 +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )          & 
&                                                 +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                end do           ! longitudinal
                j = xdim-2
                jm1=j-1; jm2=j-2; jm3=j-3; jp1=xdim-1; jp2=xdim-1; jp3=1
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                j = xdim-1
                jm1=j-1; jm2=j-2; jm3=j-3; jp1=xdim; jp2=1; jp3=2
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                j = xdim
                jm1=j-1; jm2=j-2; jm3=j-3; jp1=1; jp2=2; jp3=3
                dTxh(j)= ccx2 * (                                                              &
&                          -uclim_m(j,k,ityr)*( 10*wz(jm1,k)*(T1h(j)   - T1h(jm1) )            &
&                                               +4*wz(jm2,k)*(T1h(jm1) - T1h(jm2) )            & 
&                                               +1*wz(jm3,k)*(T1h(jm2) - T1h(jm3) ) )          &
&                         + uclim_p(j,k,ityr)*( 10*wz(jp1,k)*(T1h(j)   - T1h(jp1) )            &
&                                               +4*wz(jp2,k)*(T1h(jp1) - T1h(jp2) )            & 
&                                               +1*wz(jp3,k)*(T1h(jp2) - T1h(jp3) ) ) ) /20.
                where(dTxh .le. -T1h ) dTxh = -0.9*T1h ! no negative q;  numerical stability                
                T1h = T1h + dTxh
            end do               ! additional time loop
            dTx(:,k) = T1h - T1(:,k)
        end if
    end do          ! y-loop
    dX_advec = dTx + dTy;

end subroutine advection
