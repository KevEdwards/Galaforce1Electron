\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"FLAGS"
\\ B%=P%
\\ [OPT pass
 
.liveson
 LDX lives:BEQ noliveson
 LDA #&7E:STA addres+1:LDA #&B0:STA addres
.liveon0 LDY #15
.liveon1 LDA shipgra,Y:EOR(addres),Y:STA(addres),Y:DEY:BPL liveon1
 LDAaddres:SEC:SBC#16:STAaddres
 BCSliveon2
 DEC addres+1
.liveon2
 DEX:BNE liveon0
.noliveson RTS
 
.flagson
 LDYcurwave:INY:STYtemp
 LDA#&7D:STAaddres+1:LDA#&80:STAaddres
 LDA#&7E:STAaddres1+1:LDA#&C0:STAaddres1
 
.flag0 LDAtemp:BEQnomoflags
 CMP#10:BCCflag1
 SEC:SBC#10:STAtemp
 LDA#&88
 LDX#0
.flago0 PHA:LDY#15
.flago1 LDAflaggra,X:EOR(addres),Y:STA(addres),Y
 INX:DEY:BPL flago1
.poleon
 PLA:STAflon1+1:LDY#7
.flon1
 LDA#&FF:EOR(addres1),Y:STA(addres1),Y
 DEY:BPLflon1
 LDAaddres:CLC:ADC#16:STAaddres:LDAaddres+1:ADC#0:STAaddres+1
 LDAaddres1:CLC:ADC#16:STAaddres1:LDAaddres1+1:ADC#0:STAaddres1+1:BNEflag0
.nomoflags RTS
 
.flag1 CMP#5:BCCflag2:SEC:SBC#5:STAtemp:LDA#8:LDX#16:BNEflago0
.flag2 SEC:SBC#1:STAtemp:LDA#&80:LDX#32:BNEflago0
 
.flaggra
\ 10 flag
 EQUB0:EQUB&CC:EQUB&2E:EQUB&AE:EQUB&2E:EQUB&CC:EQUB0:EQUB0
 EQUB&FF:EQUB&FF:EQUB&AF:EQUB&AF:EQUB&AF:EQUB&FF:EQUB&FF:EQUB&88
\ 5 flag
 EQUB0:EQUB8:EQUB&C:EQUB&E:EQUB&C:EQUB8:EQUB0:EQUB0
 EQUB&E:EQUB&7F:EQUB&1F:EQUB&7F:EQUB&4F:EQUB&7F:EQUB&E:EQUB8
\ 1 flag
 EQUB0:EQUB&80:EQUB&C0:EQUB&E0:EQUB&C0:EQUB&80:EQUB0:EQUB0
 EQUB&E0:EQUB&F0:EQUB&D2:EQUB&D2:EQUB&D2:EQUB&F0:EQUB&E0:EQUB&80
 
.shipgra
 EQUB0:EQUB0:EQUB0:EQUB&15:EQUB&77:EQUB&76:EQUB&77:EQUB&11
 EQUB8:EQUB&88:EQUB&88:EQUB&CD:EQUB&F7:EQUB&F3:EQUB&FF:EQUB&44
 
\\ ]
\\ PRINT"Flags etc. from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
