************************************************
*       GREB-GCR | Script GrADS Example        *                                 
*                                              *
*  08/11/2017 - Author: Emerson D. Oliveira    *
*                                              *
*   e-mail: emerson.oliveira@univasf.edu.br    *
************************************************

*
* This script make a temperature average adopting the function color, for more details visit: http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=en 
*

'reinit'

'open scenario.ctl'  
   
'set display color white'
'clear'
'set mproj robinson'
'set lon -180 180'
'set mpdset hires'
'set grads off'
*'set grid off'


**************************************
*   TSURF ANNUAL MEAN [1960-1990]    *
**************************************

'tmmDEC=ave(tmm,time=00Z01dec1960,time=00Z01dec1990,12)'     
'tmmJAN=ave(tmm,time=00Z01jan1960,time=00Z01jan1990,12)'
'tmmFEB=ave(tmm,time=00Z01feb1960,time=00Z01feb1990,12)'
'tmmMAR=ave(tmm,time=00Z01mar1960,time=00Z01mar1990,12)'     
'tmmAPR=ave(tmm,time=00Z01apr1960,time=00Z01apr1990,12)'
'tmmMAY=ave(tmm,time=00Z01may1960,time=00Z01may1990,12)'
'tmmJUN=ave(tmm,time=00Z01jun1960,time=00Z01jun1990,12)'     
'tmmJUL=ave(tmm,time=00Z01jul1960,time=00Z01jul1990,12)'
'tmmAUG=ave(tmm,time=00Z01aug1960,time=00Z01aug1990,12)'
'tmmSEP=ave(tmm,time=00Z01sep1960,time=00Z01sep1990,12)'     
'tmmOCT=ave(tmm,time=00Z01oct1960,time=00Z01oct1990,12)'
'tmmNOV=ave(tmm,time=00Z01nov1960,time=00Z01nov1990,12)'

'tmmANUAL=(tmmDEC+tmmJAN+tmmFEB+tmmMAR+tmmAPR+tmmMAY+tmmJUN+tmmJUL+tmmAUG+tmmSEP+tmmOCT+tmmNOV)/12'

'tsurf = tmmANUAL - 273.15'

'set gxout shaded'

'color -30 30 -div 20 -kind blue->cornflowerblue->skyblue->khaki->orange->red'

'd tsurf'

'run cbar'

'printim anual_tsurf_19601990.png'

'quit'


