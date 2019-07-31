************************************************
*       GREB-GCR | Script GrADS Example        *                                 
*                                              *
*  08/11/2017 - Author: Emerson D. Oliveira    *
*                                              *
*   e-mail: emerson.oliveira@univasf.edu.br    *
************************************************

*
* This script make an ocean mask adopting the function color (http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=en)
* 

'reinit'

'open scenario.ctl'  

'set display color white'
'clear'
'set lon -180 180'
'set grads off'
'set grads off'
'set t last'

'set gxout shaded'
'color -30 30 -div 20 -kind blue->cornflowerblue->skyblue->khaki->orange->red'
'tocean=tomm-273.15'
'd tocean'
'basemap L 15 19 L'
'cbarn'
'set font 2'
'draw title Tocean'

'printim ../EXP20/maskTocean.png'

'quit'
