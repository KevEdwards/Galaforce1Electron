\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"ROUT3"
\\ B%=P%
\\ [OPT pass
 
.move_my_base
 LDAmyst:BPLok_to_move
 RTS
 
.ok_to_move
 JSRprocess_demo
 LDY#0:STYtemp3+1:STYtemp3
 BITdemo_flag:BPLmanual_control
 INY
 BITdemo_direction:BPLdem_right
 INY
.dem_right
 STYtemp3
 JMPpossible_move
 
.manual_control
 BITkey_joy_flag
 BMIuse_keyboard
 BITjoytype:BMIrx1stbyte
 
 LDX#1:JSRcheck_joy
 ROLtemp3
 LDX#1:JSRcheck_joy2
 ROLtemp3
 LDX#2:JSRcheck_joy
 ROLtemp3+1
 LDX#2:JSRcheck_joy2
 ROLtemp3+1
 JMPpossible_move
 
.rx1stbyte
 LDA&FCC0:EOR#&FF
 LSRA:ROLtemp3+1
 LSRA:ROLtemp3+1
 LSRA:ROLtemp3
 LSRA:ROLtemp3
 JMPpossible_move
 
.use_keyboard
 LDX#&9E:JSRcheck_key:\ Z key
 ROLtemp3
 LDX#&BD:JSRcheck_key:\ X key
 ROLtemp3
 LDX#&B7:JSRcheck_key:\ colon key
 ROLtemp3+1
 LDX#&97:JSRcheck_key:\ / key
 ROLtemp3+1
 
.possible_move
 JSRpokmypos
 LDYtemp3
 LDAmyx:STAtemp3
 LDAkey_press_relx,Y
 CLC:ADCmyx
 CMP#74:BCSbad_x_position
 STAmyx
.bad_x_position
 LDYtemp3+1
 LDAmyy:STAtemp3+1
 LDAkey_press_rely,Y
 CLC:ADCmyy
 CMP#165:BCCbad_y_pos
 CMP#235:BCSbad_y_pos
.good_y_pos
 STAmyy
.bad_y_pos
 LDYmyy:LDXmyx
 CPXtemp3:BNEship_has_moved
 CPYtemp3+1:BEQship_hasnt_moved
.ship_has_moved
 JSRxycalc
 STAscreen2+1
 STXscreen2
 LDA#myheight:STAtemp1+1
 LDAtemp3:LDXmyx
 JSRsus_mygra
 JMPsprite
 
.ship_hasnt_moved
 LDAdemo_direction
 EOR#&80
 STAdemo_direction
 JMPdelay
 
.sus_mygra
 LSRA:BCCnoshf
 LDAgraph+36+40:PHA
 LDAgraph+37+40:STAtemp1
 JMPsu2
.noshf
 LDAgraph+36:PHA
 LDAgraph+37:STAtemp1
.su2
 TXA
 LSRA:BCCnoshf2
 LDXgraph+36+40
 LDYgraph+37+40
 PLA:RTS
.noshf2
 LDXgraph+36
 LDYgraph+37
 PLA:RTS
 
.key_press_rely
 EQUB0:EQUB3:EQUB-3:EQUB0
.key_press_relx
 EQUB0:EQUB1:EQUB&FF:EQUB0
 
\------------------------------
 
 
.print_scores
 STXtemp1
.pscore3
 LDYscoff,X
 TXA:LSRA:LDA#0:ADC#&A
 STAdigdt+2
 LDAscore_base,X
 BMIpscr2
 ASLA:ASLA:ASLA:ASLA
 STAdigdt+1
 LDX#15
.pscore1
 LDA&5838,Y
.digdt
 EOR&A00,X:\ Digit graphics
 STA&5838,Y
 DEY
 DEX:BPLpscore1
.pscr2
 LDXtemp1
 RTS
 
.init_score
 JSRreset_score_to_0
.poke_hi_scr
 JSRclrhi
 LDX#8:STXtemp2
.inscr1
 LDAscore_base,X:BNEinscr2
 LDYtemp2:BNEinscr3
.inscr2
 LDA#0:STAtemp2
 JSRprint_scores
.inscr3
 INX:CPX#15:BNEinscr1
 RTS
 
.add_to_score
 LDAalgra,X:SEC:SBC#12
 LSRA:TAX
 LDAalien_score,X
 
 LDX#5
.addscr2
 PHA
 JSRprint_scores
 PLA
 CLC
 ADCmyscore,X
 AND#&7F
 CMP#10:BCCaddscr3
 SBC#10
 STAmyscore,X
 JSRprint_scores
 LDA#1
 DEX:BPLaddscr2
 JMPreset_score_to_0
.addscr3
 STAmyscore,X
 CPX#2:BNEnot_ten_thousands
 BITextra_life_flag
 BMInot_ten_thousands
 CMP#2:BNEnot_ten_thousands:\ extra life at >=20000
 SEC:RORextra_life_flag
 TXA:PHA
 JSRliveson
 INClives
 JSRliveson
 PLA:TAX
.not_ten_thousands
 JMPprint_scores
 
 
.scoff
 EQUB0+15:EQUB8+15:EQUB24+15:EQUB32+15
 EQUB48+15:EQUB56+15:EQUB72+15
 
 EQUB0:\ Dummy entry
 EQUB0+15+&98:EQUB8+15+&98:EQUB24+15+&98:EQUB32+15+&98
 EQUB48+15+&98:EQUB56+15+&98:EQUB72+15+&98
 
.check_new_high
 BITdemo_flag:BMInot_new_high
 LDX#&FF
.new_high1
 INX:CPX#7:BEQnot_new_high
.new_high2
 LDAmyscore,X:AND#&7F
 CMPhiscore,X
 BEQnew_high1
 BCCnot_new_high
.copy_to_high
.copyh2
 LDAmyscore,X:AND#&7F
 STAhiscore,X
 INX:CPX#7:BCCcopyh2
.not_new_high
 RTS
 
.clrhi
 LDX#12*8-1:LDA#0
.clrhgh
 STA&58D0,X
 DEX:BPLclrhgh
 RTS 
 
.reset_score_to_0
 LDY#6:LDA#&80
.zero_my_score
 STAmyscore,Y
 DEY:BPLzero_my_score
 LDA#0:STAmyscore+6
 LDX#12*8:\         WAS 11
.clr_score_screen
 STA&5837,X
 DEX:BNEclr_score_screen
 LDX#6:JMPprint_scores
 
.toggle_demo_direct
 LDAdemo_direction:EOR#&80
 STAdemo_direction
 RTS
 
\ Points awarded for aliens
\ (divided by ten)
 
.alien_score
 EQUB2:EQUB2:EQUB2:EQUB2
 EQUB4:EQUB4:EQUB4:EQUB4
 EQUB6:EQUB6
 EQUB8:EQUB8
 EQUB 2:\ Dummy for my ship
 EQUB 8
 
\\ ]
\\ PRINT"Routine 3  from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
