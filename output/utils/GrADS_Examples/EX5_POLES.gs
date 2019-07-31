************************************************
*       GREB-GCR | Script GrADS Example        *                                 
*                                              *
*  06/11/2017 - Author: Emerson D. Oliveira    *
*                                              *
*   e-mail: emerson.oliveira@univasf.edu.br    *
************************************************

*
* This script make a panel adopting the funciton mul, for more details visit: http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=en 
*

'reinit'

'open scenario.ctl'  
   
'set display color white'
'clear'
'set lon -180 180'
'set grads off'
'set grid off'

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

***** Plot North Pole *****
'mul 1 2 1 2' 
'set grads off'
'set mproj nps'
'set lat 60 90'
'set gxout shaded'
'color -20 10 -div 15 -kind blue->cornflowerblue->skyblue->khaki->orange->red'
'd tsurf'
'set font 0'
'cbarn'
'set font 2'
'draw title Tsurf North Pole'

***** Plot South Pole *****
'mul 1 2 1 1'
'set grads off'
'set mproj sps'
'set lat -90 -60'
'set gxout shaded'
'color -20 10 -div 15 -kind blue->cornflowerblue->skyblue->khaki->orange->red'
'd tsurf'
'draw title Tsurf South Pole'

***** printing figure plot *****
'printim panel_poles.png'

'quit'
