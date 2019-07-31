************************************************
*       GREB-GCR | Script GrADS Example        *                                 
*                                              *
*  08/11/2017 - Author: Emerson D. Oliveira    *
*                                              *
*   e-mail: emerson.oliveira@univasf.edu.br    *
************************************************

'reinit'

'open scenario.ctl'

'set display color white'
'c'

*************************************
*                                   *
*      Surface Temperature          *
*                                   *
*************************************
'set lat -7.5'
'set lon -40'
'set t 1 last'
'set vpage 2 10.5 5.3 8.20'
'set parea 0.7 8.0 0.35 1.6'
'set string 2 l 6'
'set strsiz .12 .13'
'draw string 0.7 1.8 Tsurf (oC)'
'set string 11 l 20'
'set strsiz .20 .26'
'draw string 1.7 3.0 GRAPHS - Northeast of Brazil'
'set string 1 l 6'
'set strsiz .13 .17'
'draw string 2.0 2.5 GREB-GCR EXPXX | Lat:-7.5  Lon:-40 '
'set grads off'
'set gxout line'
'set cmark 0'
'set ylab on'
'set ylint 2'
'set vrange 22 30'
'set ccolor 2'
'set cthick 1'
'ts=tmm-273.15'
'd ts'


*****************************************************************

**************************************
*                                    *
*        Ocean Temperature           *
*                                    * 
**************************************
'set vpage 2 10.5 3.80 5.40'
'set parea 0.7 8.0 0.35 1.6'
'set grads off'
'set string 5 l 6'
'set strsiz .12 .13'
'set ccolor 1'
'draw string 0.7 1.8 Tocean (oC)'
'set ylint 1'
'set vrange 23 26'
'set ccolor 5'
'set cthick 1'
'to=tomm-273.15'
'd to'


*******************************************************************

************************************
*                                  *
*     Atmospheric Temperature      *
*                                  *
************************************
'set vpage 2 10.5 2.30 4.0'
'set parea 0.7 8.0 0.35 1.6'
'set grads off'
'set gxout line'
'set cmark 0'
'set ylab on'
'set string 9 l 6'
'set strsiz .12 .13'
'draw string 0.7 1.8 Tatmos (oC)'
'set string 4 l 6'
'set ylint 2'
'set vrange 26 32'
'set ccolor 9'
'set cthick 1'
'ta=tamm-273.15'
'd ta'

*****************************************************************

*********************************
*                               *
*     Specific Humidity         *
*                               *
*********************************
'set vpage 2 10.5 0.8 2.60'
'set parea 0.7 8.0 0.35 1.6'
'set grads off'
'set gxout line'
'set cmark 0'
'set ylab on'
'set string 15 l 6'
'set strsiz .12 .13'
'draw string 0.7 1.8 Specific Humidit (g/kg)'
'set string 15 l 6'
'set ylint 1'
'set ccolor 15'
'set cthick 1'
'sh=qmm*1000'
'd sh'

'printim graphs.png x1600 y1200'

'quit'
