************************************************
*       GREB-GCR | Script GrADS Example        *                                 
*                                              *
*  08/11/2017 - Author: Emerson D. Oliveira    *
*                                              *
*   e-mail: emerson.oliveira@univasf.edu.br    *
************************************************

*************************************
*                                   *
*  Global Mean Tsurf in ASCII File  *
*                                   *
*************************************

'reinit'
'open scenario.ctl'

'set t 1 last'
'set gxout print'
'set prnopts %f 1'
'a=aave(tmm,global)'
'ts=a-273.15'
'set lat 1'
'set lon 1'
'd ts'
rc = write(global.tsurf.txt,result)
'quit'
