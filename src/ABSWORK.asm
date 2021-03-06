\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"ABSWORK"
\\ P%=&400:ST%=P%:O%=&3000
\\ [OPT 6

\\ Map normal ASCII
MAPCHAR ' ','Z', 32

ORG &400

.alst			SKIP maxaliens
.algra			SKIP maxaliens
.alpatlow		SKIP maxaliens
.alpathigh		SKIP maxaliens
.alpatoff		SKIP maxaliens
.alcount		SKIP maxaliens
.almult			SKIP maxaliens
.aldirect		SKIP maxaliens
.alx 			SKIP maxaliens
.aly 			SKIP maxaliens
.al_loop_count	SKIP maxaliens
.al_loop_start	SKIP maxaliens
.alpatreflect	SKIP maxaliens
 
.mybullx 		SKIP mymaxbull
.mybully 		SKIP mymaxbull
.mybullst 		SKIP mymaxbull
 
.albullx		SKIP almaxbull
.albully 		SKIP almaxbull
.albullst 		SKIP almaxbull
.albullspeed	SKIP almaxbull
 
.lives 			EQUB 0
.myx 			EQUB 0
.myy			EQUB 0
.myst			EQUB 0
.score_base
.myscore 		SKIP 8
.hiscore 		SKIP 7
 
.wavoff			EQUB 0
.almove			EQUB 0
.curwave		EQUB 0
.procst			EQUB 0
.mybullact		EQUB 0
.albullact		EQUB 0
.initact		EQUB 0
.bombdel		EQUB 0

.sound_flag			EQUB 0
.key_joy_flag		EQUB 0
.demo_flag			EQUB 0
.demo_count			EQUB 0
.demo_direction		EQUB 0
.counter_sound		EQUB 0
.extra_life_flag	EQUB 0
.sixteen_flag		EQUB 0
.pause_flag			EQUB 0

.dummy EQUB 0
.wtflg EQUB 0
.demsect EQUB 0
 
.alfx EQUB 0
.alfx2 EQUB 0
 
.hstxt
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
 EQUS"1234567890"
.hsnum
 EQUS"1234567"
 EQUS"1234567" 
 EQUS"1234567"
 EQUS"1234567"
 EQUS"1234567"
 EQUS"1234567"
 EQUS"1234567"
 EQUS"1234567"
 
.joytype		EQUB 0
.joyval			EQUB 0:EQUB 0
 
\\ ]
\\ PRINT"General workspace from &";~ST%;" to &";~P%-1
 
\\ PAGE=PG%
\\ RETURN
 
\\ DEFFNres(gap%)
\\ P%=P%+gap%:O%=O%+gap%
\\ =6
