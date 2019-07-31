   program  time_ex

! Modified by Emerson D. Oliveira - 10/10/2017

  USE mo_numerics
  USE mo_physics

! declare output fields
  real, dimension(xdim,ydim,ndays_yr) :: Tc1, Ta1, q1, ap1
  real, dimension(xdim,ydim,ndays_yr) :: Tc2, Ta2, q2, ap2

  integer, dimension(ndays_yr)::  t = (/(i,i=1,ndays_yr)/) ! jday index

  integer :: narg, ntime 

100 FORMAT('climate: ',F9.2, 5E12.4)

  print*,'% start climate shell'
  print*,'%'

  ipx=48-10; ipy=24-2
  print*,'% diagonstic point lat/lon: ',3.75*ipy-90, 3.75*ipx-180
  
! open input files
  open(unit=10,file='namelist')
  open(unit=11,file='../input/tsurf',           ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=12,file='../input/vapor',           ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=13,file='../input/topography',      ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=14,file='../input/soil.moisture',   ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=15,file='../input/solar.radiation', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*ydim*nstep_yr)
  open(unit=16,file='../input/zonal.wind',      ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=17,file='../input/meridional.wind', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=18,file='../input/ocean.mld',       ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=19,file='../input/cloud.cover',     ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=20,file='../input/glacier.masks',   ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*xdim*ydim)
  open(unit=23,file='../input/sunspot',         ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*time_yr)
  open(unit=24,file='../input/co2',             ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*time_yr) 

! read namelist 
  read(10,numerics)
  read(10,physics) 

! read fix data
  read(13,rec=1)  z_topo
  read(15,rec=1)  sw_solar
  read(20,rec=1)  glacier 
  read(23,rec=1)  sn(:)
  read(24,rec=1)  hco2(:)
 
  do n=1,nstep_yr
     read(11,rec=n) tclim(:,:,n)
     read(unit=12,rec=n) qclim(:,:,n)
     read(unit=14,rec=n) swetclim(:,:,n)
     read(unit=16,rec=n) uclim(:,:,n)	
     read(unit=17,rec=n) vclim(:,:,n)
     read(unit=18,rec=n) mldclim(:,:,n)
     read(unit=19,rec=n) cldclim(:,:,n)
  end do

! define deep ocean temp. as min of Tsurf but > 3.0 Celcius
  forall (i=1:xdim, j=1:ydim)
     Toclim(i,j,:) = minval(Tclim(i,j,:))
  end forall
  where (Toclim(:,:,1)-273.15 < -1.7) Toclim(:,:,1) = -1.7+273.15
  forall (i=1:xdim, j=1:ydim)
     Toclim(i,j,:) = Toclim(i,j,1)
  end forall

  print*,'% time flux/control/scenario:',time_flux, time_ctrl, time_scnr  
  print*,'% log_exp/var_cloud/max_sn:',log_exp, var_cloud, max_sn 
  print*,'%'
  call greb_model
 
  END
