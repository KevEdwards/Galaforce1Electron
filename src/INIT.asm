\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"INIT"
\\ B%=P%
\\ [OPT pass

.exec
 JSRStop
 SEI
 LDA#demsnd MOD 256:STA&220
 LDA#demsnd DIV 256:STA&221
 CLI
 LDA#16:LDX#0
 JSRosbyte:\ Conversion channels=0
 LDA#163:LDX#128:LDY#1
 JSRosbyte:\ Turn off ADC IRQs
 LDX#&FF:TXS
 LDY#&F:LDA#0
.setup_hiscore
 STAmyscore-1,Y
 DEY:BNEsetup_hiscore
 LDA#3:STAhiscore+2
 
\ BBC Ver only!
 
 \ LDA#&90 LDX#0 LDY#1 JSRosbyte
 
 JSRpalch
 JSRseed_rnd
 JSRstarinit
 LDY#2:JSRprnstr
 LDY#4:JSRprnstr
 LDA#&80:STAsound_flag
 STApause_flag
 STAkey_joy_flag
 STAjoytype
 JSRdisplay_sound_status
 JSRdisplay_key_joy_status
 JSRprnjoytyp
 
 JSRinit_score
 JSRwait_for_space
 TAY
 
\   The 'game' loop
 
.restart
 LDA#3:STAlives
 STAsixteen_flag:\ +ve allows it to be printed
 STAextra_life_flag
 STYcurwave
 LDAvecwavl,Y:STAwavbase
 LDAvecwavh,Y:STAwavbase+1
 LDA#14:LDX#4:JSRosbyte
 JSRkbdoff
 JSRflagson
 LDAdemo_flag:BMIrestart2
 LDY#0:JSRStartTune
.restart2
 SEC:RORwtflg
 LDA#0:STAwavoff
 LDY#process:STYaliens
 DEY:STYaliensm1
 
 JSRinit_score
 JMPfirst_life
 
.next_life
 JSRliveson
 LDY#0:LDA(wavbase),Y
 STAaliens
 SEC:SBC#1:STAaliensm1
 CLC:RORwtflg
 DECwavoff
 DEClives
 \ BNEfirst_life
 \ LDX#lstman MOD 256
 \ LDY#lstman DIV 256
 \ JSRmksnd
.first_life
 JSRliveson
 JSRrstall
 JSRpokmypos
 LDA#&C0:STAscreen2+1
 LDAmyx:TAX
 JSRsus_mygra
 JSRsprite
 JSRmessage_loop
 
.main_loop
 CLI
 INCcounter
 JSRescape
 JSRrand
 JSRmove_my_base
 JSRmovestars
 JSRinit_new_aliens
 JSRmove_the_aliens
 JSRprocess_my_bombs
 JSRprocess_aliens_bombs
 JSRcollision
 
 LDAmyst:BPLmain_loop
 LDAalmove:BPLmain_loop
 LDAalbullact:ORAmybullact
 BNEmain_loop
 JSRdie_loop
 LDAlives:BNEnext_life
 JSRcheck_new_high
 LDA#&31:STAscreen+1
 JSRpoke_hi_scr
 JSRgame_over_loop
 JSRahigh
 JSRwait_for_space
 PHA
 JSRflagson
 PLA:TAY
 JMPrestart
 
.wait_for_space
 JSRend_message
 LDA#0:STAcounter
 
.space_loop
 JSRsrlp
 JSRcycle
 INCcounter:BEQhsclp
 LDX#&9D:JSRcheck_key
 BNEspace_loop
 JSRend_message
.jkch
 LDA#0:STAdemo_flag
 RTS
 
.hsclp
 JSRend_message
 JSRpht
.hscl2
 JSRsrlp
 INCcounter:BEQinto_demo
 LDX#&9D:JSRcheck_key
 BNEhscl2
 JSRpht
 JMPjkch
 
.into_demo
 JSRpht
 LDX#&FF:STXdemo_flag
 STXdemo_count
 INX:STXdemsect
 JSRrand:AND#7:\ Random start for demo
 RTS
 
.process_demo
 LDAdemo_flag:BPLnot_in_demo
 DECdemo_count:BPLnot_in_demo
 LDArand1+1:STAdemo_direction
 AND#15:ADC#10:STAdemo_count
.not_in_demo
 RTS
 
.die_loop
 BITdemo_flag:BMIdl1
 LDA#15:LDX#0:JSRosbyte
 LDY#20:JSRStartTune
.dl2
 JSRmovestars
 JSRpause
 LDX#18:JSRsdel
 JSRMusicTest
 BNEdl2
.dl1
 RTS
 
.palch
 LDX#0
.palc2
 LDAvdus,X:BMIvdu2
 JSRoswrch
 INX:BNEpalc2
.vdu2
 RTS
 
.vdus
 EQUB22:EQUB5
 EQUB23:EQUB1:EQUB0:EQUB0:EQUB0:EQUB0:EQUB0:EQUB0:EQUB0:EQUB0
 EQUB19:EQUB2:EQUB4:EQUB0:EQUB0:EQUB0
 EQUB&FF
 
.lstman
 EQUW &11
 EQUW 3
 EQUW 80
 EQUW 20
 
.demsnd
 CMP#4:BNEexdem2
 BITpause_flag:BPLexdem2
 TXA:PHA:TYA:PHA
 JSRrdp1joy
 JSRRefresh
 JSRMusicTest:BNEexdem
 DECdemsect
 BPLdemsn2
 LDA#7:STAdemsect
.demsn2
 LDXdemsect:LDYdemtab,X
 LDAdemo_flag:BPLexdem
 JSRStartTune
 JSRRefresh
.exdem
 PLA:TAY:PLA:TAX
.exdem2
 RTS
 
.demtab
 EQUB40:EQUB40:EQUB35:EQUB35
 EQUB30:EQUB30:EQUB15:EQUB15
 
.srlp
 LDX#18:JSRsdel
 JSRmovestars
 JMPpause
 
.rdp1joy
 BIT&FC72:BVSrdp1jo3
 LDA&FC70
.rdp1jo2
 LDY#0:STAjoyval,Y
 TYA:EOR#1:STArdp1jo2+1
 ORA#4:STA&FC70
.rdp1jo3
 RTS
 
\\ ]
\\ PRINT"Init       from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
