\\
\\ Galaforce 1 Electron
\\
\\ (C) Kevin Edwards 1986-2019
\\

objstrt%	=&E00	\ Start of main code, however, data is loaded below this later which is downloaded to other parts of memory ( to &700 and &A00 - see DOWN.asm )
codeend%	=&2F00	\ End of memory available for code ( graphics are loaded above this area )
objend%		=&3A00	\ End of code/graphics, where the Downloader is positioned
objexec%	=&4800	\ Execution address when loaded to &1900 rather than &900 ( objend% + &1900 - &e00 + &300 )

	INCLUDE "src\CONST.asm"
	INCLUDE "src\ZPWORK.asm"
	INCLUDE "src\ABSWORK.asm"
 
	 \\ Normal ASCII
	MAPCHAR ' ','Z', 32

	ORG objstrt% - &300
	INCBIN "object\O.SPFONT"

	ORG objstrt% - &200
	INCBIN "object\O.DIGITS"

	\\ Main Code block - source files assembled in the same order as the original
	ORG objstrt%
	INCLUDE "src\SPRITES.asm"
	INCLUDE "src\INIT.asm"
	INCLUDE "src\ALIENS1.asm"
	INCLUDE "src\ALIENS2.asm"
	INCLUDE "src\ALIENS3.asm"
	INCLUDE "src\ALIENS4.asm"
	INCLUDE "src\ROUT1.asm"
	INCLUDE "src\ROUT2.asm"
	INCLUDE "src\ROUT3.asm"
	INCLUDE "src\ROUT4.asm"
	INCLUDE "src\STARS.asm"
	INCLUDE "src\BOMBS1.asm"
	INCLUDE "src\BOMBS2.asm"
	INCLUDE "src\CHARP.asm"
	INCLUDE "src\FLAGS.asm"
	INCLUDE "src\TITLE.asm"
	INCLUDE "src\CYCLE.asm"
	INCLUDE "src\HIGH.asm"
	INCLUDE "src\MUSIC1.asm"
	INCLUDE "src\MUSIC2.asm"
	INCLUDE "src\MUSIC3.asm"
	INCLUDE "src\WAVE.asm"
	INCLUDE "src\PATT.asm"
	INCLUDE "src\PATDAT.asm"
	INCLUDE "src\VECTORS.asm"
	
	objcodeend = P%
	PRINT"Code start  = ",~objstrt%
	PRINT"End of code = ",~objcodeend-1
	PRINT"Length      = ",~objcodeend-objstrt%,"    (",objcodeend-objstrt%,") bytes"
	PRINT"Bytes left  = ",~codeend%-objcodeend,"   (",codeend%-objcodeend,") bytes"

	\\ Include the graphics object file after the code ( From &2F00 to &394F )
	ORG codeend%
	INCBIN "object\O.GRAPHIC"
	
	\\ Include the Downloader binary at its GENUINE load address
	ORG objend%
	INCBIN "O.DOWN"

	\\ SAVE out everything
	PRINT "Saving GAME ", ~objstrt% - &300, ~objend% + &200, ~objexec%, ~&1900
	SAVE "GAME", objstrt% - &300, objend% + &200, objexec%, &1900

	\\ Save Main Basic Loader ( gets tokenised first )
	PUTBASIC "bas_extra\ELKENV1.bas.txt","$.L"

	