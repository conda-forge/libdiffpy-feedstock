scons -j%CPU_COUNT%
if errorlevel 1 exit 1
scons lib install prefix=%PREFIX%
if errorlevel 1 exit 1
