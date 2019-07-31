!+++++++++++++++++++++++++++++++++++++++
subroutine diffusion(T1, dX_diffuse,h_scl, wz)
!+++++++++++++++++++++++++++++++++++++++
!    diffusion

  USE mo_numerics,   ONLY: xdim, ydim, dt, dlon, dlat, dt_crcl
  USE mo_physics,    ONLY: pi, z_topo, log_exp, kappa, z_vapor
  implicit none

  real, dimension(xdim,ydim), intent(in)  :: T1, wz
  real                      , intent(in)  :: h_scl
  real, dimension(xdim,ydim), intent(out) :: dX_diffuse

  integer :: i
  integer, dimension(ydim)   :: ilat = (/(i,i=1,ydim)/) 
  real, dimension(ydim)      :: lat, dxlat, ccx
  real, dimension(xdim)      :: T1h, dTxh
  real, dimension(xdim,ydim) :: dTx, dTy
  
  real    :: deg, dd, dx, dy, dyy, ccy, ccx2
  integer :: j, k, km1, kp1, jm1, jm2, jm3, jp1, jp2, jp3
  integer :: time2, dtdff2, tt2

  deg = 2.*pi*6.371e6/360.;   ! length of 1deg latitude [m] 
  dx = dlon; dy=dlat; dyy=dy*deg
  lat = dlat*ilat-dlat/2.-90.;  dxlat=dx*deg*cos(2.*pi/360.*lat)
  ccy=kappa*dt_crcl/dyy**2
  ccx=kappa*dt_crcl/dxlat**2

     ! latitudinal   
     do k=1, ydim
        km1=k-1;  kp1=k+1
        if ( k>=2 .and. k<=ydim-1)   dTy(:,k)=ccy*(                                      & 
&                         wz(:,km1)*(T1(:,km1)-T1(:,k)) +wz(:,kp1)*(T1(:,kp1)-T1(:,k)) )
        if ( k==1 )                  dTy(:,k)=ccy*wz(:,kp1)*(-T1(:,k)+T1(:,kp1))
        if ( k==ydim )               dTy(:,k)=ccy*wz(:,km1)*(T1(:,km1)-T1(:,k))
        ! longitudinal
        if ( dxlat(k) > 2.5e5) then  ! unitl 25degree
           j = 1
           jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = xdim; jm2 = xdim-1; jm3 = xdim-2
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           j = 2
           jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = j-1; jm2 = xdim; jm3 = xdim-1
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           j = 3
           jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = j-1; jm2 = j-2; jm3 = xdim
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           do j=4, xdim-3              ! longitudinal
              jm1=j-1; jp1=j+1; jm2=j-2; jp2=j+2; jm3=j-3; jp3=j+3
              ! 3.order solution: stable unitl 84degree (dx=2.5degree, a=5e5)
              dTx(j,k)=ccx(k)*(                                                           &
&               10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&               +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&               +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&               +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&               +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           end do
           j = xdim-2
           jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = j+1; jp2 = j+2; jp3 = 1;
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           j = xdim-1
           jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = j+1; jp2 = 1; jp3 = 2
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
           j = xdim
           jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = 1; jp2 = 2; jp3 = 3
           dTx(j,k)=ccx(k)*(                                                           &
&            10*( wz(jm1,k)*(T1(jm1,k)-T1(j,k))   +wz(jp1,k)*(T1(jp1,k) -T1(j,k))   )  &
&            +4*( wz(jm2,k)*(T1(jm2,k)-T1(jm1,k)) +wz(jm1,k)*(T1(j,k)   -T1(jm1,k)) )  &
&            +4*( wz(jp1,k)*(T1(j,k)  -T1(jp1,k)) +wz(jp2,k)*(T1(jp2,k) -T1(jp1,k)) )  &
&            +1*( wz(jm3,k)*(T1(jm3,k)-T1(jm2,k)) +wz(jm2,k)*(T1(jm1,k) -T1(jm2,k)) )  &
&            +1*( wz(jp2,k)*(T1(jp1,k)-T1(jp2,k)) +wz(jp3,k)*(T1(jp3,k) -T1(jp2,k)) ) )/20.
        else  ! high resolution -> smaller time steps
            dd=max(1,nint(dt_crcl/(1.*dxlat(k)**2/kappa))); dtdff2=dt_crcl/dd
            time2=max(1,nint(float(dt_crcl)/float(dtdff2)))
            ccx2=kappa*dtdff2/dxlat(k)**2
            T1h=T1(:,k)
            do tt2=1, time2      ! additional time loop
              j = 1
              jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = xdim; jm2 = xdim-1; jm3 = xdim-2
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
              j = 2
              jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = j-1; jm2 = xdim; jm3 = xdim-1
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
              j = 3
              jp1 = j+1; jp2 = j+2; jp3 = j+3; jm1 = j-1; jm2 = j-2; jm3 = xdim;
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
                do j=4, xdim-3     ! longitudinal
                    jm1=j-1; jp1=j+1; jm2=j-2; jp2=j+2; jm3=j-3; jp3=j+3
                    dTxh(j)=ccx2*(                                                           &
&                      10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                      +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                      +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                      +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                      +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.

                end do           ! longitudinal
              j = xdim-2
              jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = j+1; jp2 = j+2; jp3 = 1
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
              j = xdim-1
              jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = j+1; jp2 = 1; jp3 = 2
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
              j = xdim
              jm1 = j-1; jm2 = j-2; jm3 = j-3; jp1 = 1; jp2 = 2; jp3 = 3
              dTxh(j) = ccx2*(                                                         &
&                10*( wz(jm1,k)*(T1h(jm1)-T1h(j))   +wz(jp1,k)*(T1h(jp1) -T1h(j))   )  &
&                +4*( wz(jm2,k)*(T1h(jm2)-T1h(jm1)) +wz(jm1,k)*(T1h(j)   -T1h(jm1)) )  &
&                +4*( wz(jp1,k)*(T1h(j)  -T1h(jp1)) +wz(jp2,k)*(T1h(jp2) -T1h(jp1)) )  &
&                +1*( wz(jm3,k)*(T1h(jm3)-T1h(jm2)) +wz(jm2,k)*(T1h(jm1) -T1h(jm2)) )  &
&                +1*( wz(jp2,k)*(T1h(jp1)-T1h(jp2)) +wz(jp3,k)*(T1h(jp3) -T1h(jp2)) ) )/20.
                where(dTxh .le. -T1h ) dTxh = -0.9*T1h ! no negative q;  numerical stability
                T1h=T1h+dTxh
            end do               ! additional time loop
            dTx(:,k)=T1h-T1(:,k)
        end if
    end do          ! y-loop
    dX_diffuse = wz * (dTx + dTy);

end subroutine diffusion

