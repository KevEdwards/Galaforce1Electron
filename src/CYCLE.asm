\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE":2.CYCLE"
\\ B%=P%
\\ [OPT pass

.cycle
 LDX#&AD:\ C key
 JSRcheck_key:BEQcyc1
 RTS
.cyc1
 JSRend_message
 LDA#20:JSRoswrch
 LDX#12:JSRpalc2
 JSRcyctxt
 LDX#2
.cyc2
 LDAvddef,X:STAvdval,X
 DEX:BPLcyc2
 
.cyclop
 LDA#3:STAtemp1
 LDX#&B6:\ Return key
 JSRcheck_key:BEQcycex
 
.cyclo2
 INCtemp5
 LDYtemp1:LDXvdkey,Y
 JSRcheck_key
 BNEcyc3
 LDAtemp5:AND#&F:BNEcyc3
 LDXtemp1:STXvdwrk+1
.cyc4
 INCvdval-1,X
 LDAvdval-1,X:AND#7
 BEQcyc4
 STAvdval-1,X
 STAvdwrk+2
 LDX#0
.cyc5
 LDAvdwrk,X:BMIcyc3
 JSRoswrch
 INX:BNEcyc5
.cyc3
 DECtemp1:BNEcyclo2
 LDX#17:JSRsdel
 JSRmovestars
 JSRpause
 JMPcyclop
 
.cycex
 JSRcyctxt:JMPend_message
 
.cyctxt
 LDY#32:JSRprnstr
 LDY#34:JSRprnstr
 LDY#36:JSRprnstr
 LDY#38:JSRprnstr
 LDY#40:JSRprnstr
 LDY#42:JMPprnstr
 
.vdval
 EQUB1:EQUB3:EQUB7
.vddef
 EQUB1:EQUB4:EQUB7
.vdwrk
 EQUB19
 EQUB0:EQUB0
 EQUB0:EQUB0:EQUB0
.vdkey EQUB&FF
 EQUB&CF:EQUB&CE:EQUB&EE
 
\\ ]
\\ PRINT"Cycle      from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
