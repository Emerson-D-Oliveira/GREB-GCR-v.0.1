!+++++++++++++++++++++++++++++++++++++++
subroutine LWradiation(Tsurf, Tair, q, CO2, LWsurf, LWair_up, LWair_down, em)
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/02/2019

! new approach with LW atmos

  USE mo_numerics,    ONLY: xdim, ydim, init_yr
  USE mo_physics,     ONLY: sig, eps, qclim, cldclim, var_cloud, max_sn, z_topo, jday, ityr,         &
&                           r_qviwv, z_air, z_vapor, dTrad, p_emi, log_exp, sn, yr, pi

! declare temporary fields
  real, dimension(xdim,ydim)  :: Tsurf, Tair, q, LWsurf, LWair, e_co2, e_cloud,   &
&                                LWair_up, LWair_down, e_vapor, em

 
  e_co2   = exp(-z_topo/z_air)*CO2         ! CO2
  e_vapor = exp(-z_topo/z_air)*r_qviwv*q   ! water vapor
  
  if(log_exp .eq. 18 .or. log_exp .eq. 19 .or. log_exp .eq. 20 ) then
     e_cloud = cldclim(:,:,ityr) + cldclim(:,:,ityr)*(cos((sn(yr+(init_yr-1700))/max_sn)*pi)*var_cloud)       ! clouds second GCR theory
  else 
     e_cloud = cldclim(:,:,ityr)           ! clouds
  end if


  if(log_exp == 11) e_vapor = exp(-z_topo/z_air)*r_qviwv*qclim(:,:,ityr)     ! sens. exp. linear-function

! total  
  em      = p_emi(4)*log( p_emi(1)*e_co2 +p_emi(2)*e_vapor +p_emi(3) ) +p_emi(7)   &
&          +p_emi(5)*log( p_emi(1)*e_co2   +p_emi(3) )                             &
&          +p_emi(6)*log( p_emi(2)*e_vapor +p_emi(3) )
  em      = (p_emi(8)-e_cloud)/p_emi(9)*(em-p_emi(10))+p_emi(10) 
  if(log_exp == 11)  em = em +0.022/(0.15*24.)*r_qviwv*(q-qclim(:,:,ityr)) ! sens. exp. linear-function
   
  LWsurf      = -sig*Tsurf**4
  LWair_down  = -em*sig*(Tair+dTrad(:,:,ityr))**4 
  LWair_up    = LWair_down 

end subroutine LWradiation
