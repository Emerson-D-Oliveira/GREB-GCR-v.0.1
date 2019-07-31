!+++++++++++++++++++++++++++++++++++++++
subroutine circulation(X_in, dX_crcl, h_scl, wz)
!+++++++++++++++++++++++++++++++++++++++
! circulation with shorter time step

  USE mo_numerics,  ONLY: xdim, ydim, dt, dt_crcl
  USE mo_physics,   ONLY: log_exp, z_vapor
  implicit none

  real, dimension(xdim,ydim), intent(in)  :: X_in, wz
  real,                       intent(in)  :: h_scl
  real, dimension(xdim,ydim), intent(out) :: dX_crcl

  real, dimension(xdim,ydim) :: X, dx_diffuse, dx_advec
  integer time, tt

  if(log_exp  <=  4 ) return
  if(log_exp .eq.  7 .and. h_scl .eq. z_vapor) return
  if(log_exp .eq. 16 .and. h_scl .eq. z_vapor) return

  time=max(1,nint(float(dt)/dt_crcl))

  X = X_in;
  if(log_exp .eq. 8 .and. h_scl .eq. z_vapor) then
     do tt=1, time   ! time loop circulation
        call diffusion(X, dx_diffuse, h_scl, wz)
        X = X + dx_diffuse
     end do           ! time loop
  else
     do tt=1, time   ! time loop circulation
        call diffusion(X, dx_diffuse, h_scl, wz)
        call advection(X, dx_advec, h_scl, wz)
        X = X + dx_diffuse + dx_advec
     end do           ! time loop
  end if
  dX_crcl = X - X_in

end subroutine circulation
