\\
\\ Galaforce 1 ( Electron ) from the original 6502 source code, adapted to assemble using beebasm
\\
\\ (c) Kevin Edwards 1986-2019
\\
\\ Twitter @KevEdwardsRetro
\\

\\ REM SAVE"ALIENS2"
\\ B%=P%
\\ [OPT pass

.process_aliens
 LDAmyst:BPLprocess_ok
 LDX#2*process:JMPsdel
 
.process_ok
 LDX#maxpatt-1
.proc1
 LDAinitst,X:BPLproc2
 LDAinitcount,X
 BEQproc6
 DECinitcount,X
.proc2
 DEX:BPLproc1
 RTS
 
.proc6
 LDAinitdel,X:STAinitcount,X
 LDYaliensm1
.proc3
 LDAalst,Y:BPLproc4
 DEY:BPLproc3
 BMIproc2:\    MIGHT PUT ALIENS OUT OF SYNC.
.proc4
 LDA#0:STAalpatoff,Y
 STAalmult,Y
 LDA#&80:STAalst,Y 
 LDAinitx,X:STAalx,Y
 PHA
 LDAinity,X:STAaly,Y
 LDAinitgra,X:STAalgra,Y
 STAtemp3
 SEC:SBC#12:LSRA
 STXtemp2+1
 TAX
 LDAalien_hits,X:STAalcount,Y
 LDXtemp2+1
 LDAinitpnum,X
 STAalpatreflect,Y
 AND#&7F:TAX
 LDAvecpatdl,X:STAalpatlow,Y
 LDAvecpatdh,X:STAalpathigh,Y
 PLA:TAX
 JSRrand:AND#31
 CPX#78:BEQalter_start_x
 CPX#79:BNEuse_original_x
 ADC#40
.alter_start_x
 STAalx,Y
.use_original_x
 LDXtemp2+1
 INCalmove
 DECinitnum,X:BNEproc5
 LDA#0:STAinitst,X
 DECinitact
.proc5
 CLC:LDAinitx,X
 ADCinitrelx,X
.chk_xinit_wrap
 CMP#80:BCCno_initx_wrap
 SBC#80:JMPchk_xinit_wrap
.no_initx_wrap
 STAinitx,X
 CLC:LDAinity,X
 ADCinitrely,X:STAinity,X
 
 LDXalx,Y:LDAaly,Y:TAY
 STXalfx:STXalfx2
 JSRalien_on_off
 LDXtemp2+1
 JMPproc2
 
.alien_on_off
 JSRxycalc
 STAscreen+1:STXscreen
 LDA#alheight:STAtemp1+1
 LDA#&C0:STAscreen2+1
 LDYtemp3
 JSRsus_algra
 JMPsprite
 
.sus_algra
 LSRalfx:BCCsual2
 LDAgraph+40,Y:PHA
 LDAgraph+41,Y:STAtemp1
 JMPsual3
.sual2
 LDAgraph,Y:PHA
 LDAgraph+1,Y:STAtemp1
.sual3
 LSRalfx2:BCCsual4
 LDXgraph+40,Y
 LDAgraph+41,Y
 TAY:PLA:RTS
.sual4
 LDXgraph,Y
 LDAgraph+1,Y
 TAY:PLA:RTS

\\ ]
\\ PRINT"Aliens 2   from &";~B%;" to &";~P%-1;" (";P%-B%;")"
\\ PAGE=PG%
\\ RETURN
