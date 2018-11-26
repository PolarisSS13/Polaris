cd ../../maps/geminus

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
