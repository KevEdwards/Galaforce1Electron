cls

beebasm -i Prebuild.mak

beebasm -i Master.mak -di G1_BLANK.ssd -do Galaforce1Electron.ssd
@Echo. Done! .ssd image has been built
dir *.ssd
