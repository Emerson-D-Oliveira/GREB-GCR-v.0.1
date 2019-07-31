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
'set mproj robinson'
'set lon -180 180'
'set grads off'

****************** AUSTRAL SUMMER *************************
'tmmDEC=ave(tmm,time=00Z01dec1960,time=00Z01dec1990,12)'     
'tmmJAN=ave(tmm,time=00Z01jan1960,time=00Z01jan1990,12)'
'tmmFEB=ave(tmm,time=00Z01feb1960,time=00Z01feb1990,12)'
'tmmSUMER=(tmmDEC+tmmJAN+tmmFEB)/3'

****************** AUSTRAL WINTER *************************
'tmmJUN=ave(tmm,time=00Z01jun1960,time=00Z01jun1990,12)'     
'tmmJUL=ave(tmm,time=00Z01jul1960,time=00Z01jul1990,12)'
'tmmAUG=ave(tmm,time=00Z01aug1960,time=00Z01aug1990,12)'
'tmmWINTER=(tmmJUN+tmmJUL+tmmAUG)/3'

***** Plot SUMMER *****
'mul 1 2 1 2' 
'set grads off'
'set gxout shaded'
'color -30 30 -div 20 -kind blue->cornflowerblue->skyblue->khaki->orange->red'
'tsurf1=tmmSUMER-273.15'
'd tsurf1'
'set font 0'
'cbarn'
'set font 2'
'draw title Tsurf Summer'

***** Plot WINTER *****
'mul 1 2 1 1'
'set grads off'
'set gxout shaded'
'color -30 30 -div 20 -kind blue->cornflowerblue->skyblue->khaki->orange->red'
'tsurf2=tmmWINTER-273.15'
'd tsurf2'
'draw title Tsurf Winter'

***** printing figure plot *****
'printim panel_fields.png'

'quit'
