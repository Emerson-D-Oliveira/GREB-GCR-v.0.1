!+++++++++++++++++++++++++++++++++++++++
subroutine co2_level(it, year, CO2)
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 05/02/2019

  USE mo_numerics,    ONLY: ndays_yr, ndt_days, nstep_yr, var_co2, init_yr
  USE mo_physics,     ONLY: log_exp, yr, hco2

  yr = ((it - 1)/nstep_yr) + 1

  CO2 = 2*var_co2  
  if( log_exp .eq. 17 .or. log_exp .eq. 18 .or. log_exp .eq. 19 ) then
     CO2_1800=280.
     if (year >=1700. .and. year <= 2017.) CO2=CO2_1800
  end if

  if( log_exp .eq. 12 .or. log_exp .eq. 13 .or. log_exp .eq. 20 ) then
     CO2=hco2(yr+(init_yr-1700))  
  end if
  
end subroutine co2_level
