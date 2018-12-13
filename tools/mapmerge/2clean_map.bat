SET z_levels=6
cd 

FOR %%f IN (../../maps/geminus/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/geminus/%%f.backup ../../maps/geminus/%%f ../../maps/geminus/%%f
)

pause