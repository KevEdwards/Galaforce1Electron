\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"STARS"
\\ B%=P%
\\ [OPT pass
 
.starinit
 LDX #90:LDY #30
 LDA #0:STA addres:STA addres+1:STA whichstar
.starin0
 JSR starpos
 JSR rand:AND #4:ORA addres:CLC:ADC stardat,X:STA stardat,X
 LDA addres+1:ADC stardat+1,X:STA stardat+1,X
 LDA addres:CLC:ADC #&40:STA addres
 LDA addres+1:ADC #1:STA addres+1
.gcol TYA:PHA
 JSR rand:EOR&FC:AND#&F:TAY
 LDA stbyte,Y
 STA stardat+2,X
 PLA:TAY
 LDA stardat+2,X
 EOR (stardat,X):STA (stardat,X)
 DEX:DEX:DEX:DEY:BPL starin0
 RTS
 
.stbyte
 EQUB8:EQUB4:EQUB2:EQUB1
 EQUB&80:EQUB&40:EQUB&20:EQUB&10
 EQUB&88:EQUB&44:EQUB&22:EQUB&11
 EQUB8:EQUB&40:EQUB&22:EQUB&10
 
.movestars
 LDY #16:LDX whichstar
 BEQ movestar:DEY
.movestar LDA stardat+2,X
 EOR (stardat,X):STA (stardat,X)
 LDA stardat,X:AND #7
 CMP #6:BCC doapix
 BEQnotofb
 CLC
.notofb
 LDA stardat,X
 ADC #&39:EOR #&80:STA stardat,X
 LDA stardat+1,X:ADC #1
 STA stardat+1,X
 BPL staron
 
.offbot
 JSR starpos
 JMP staron
 
.doapix INC stardat,X:INC stardat,X
.staron LDA stardat+2,X
 EOR (stardat,X):STA (stardat,X)
 INX:INX:INX:DEY:BNE movestar
 LDA whichstar:CLC:ADC #48
 CMP #96:BNE whstarin:LDA #0
.whstarin STA whichstar:RTS
 
.starpos JSR rand:AND #1
 CLC:ADC#&59:STA stardat+1,X
 CMP #&5A:BEQ offb2
 JSR rand:AND #&F8:ORA #&40:BNE offb3
.offb2 JSR rand:AND #&78
.offb3 STA stardat,X:RTS
 
.rand LDA rand1:AND #&48:EOR&FC:ADC #&38
 ASLA:ASLA:ROL rand1+2:ROL rand1+1
 ROL rand1:LDA rand1:RTS
 
 
\\ ]
\\ PRINT"Stars      from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
