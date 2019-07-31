!+++++++++++++++++++++++++++++++++++++++
module mo_diagnostics
!+++++++++++++++++++++++++++++++++++++++

! Modified by Emerson D. Oliveira - 10/10/2017

  USE mo_numerics,    ONLY: xdim, ydim

 ! declare diagnostic fields
  real, dimension(xdim,ydim)          :: Tsmn, Tamn, qmn, swmn, lwmn, qlatmn, qsensmn, &
&                                        ftmn, fqmn, amn, Tomn

! declare output fields
  real, dimension(xdim,ydim)          :: Tmm, Tamm, Tomm, qmm, apmm, qlatmm, qsensmm

end module mo_diagnostics

