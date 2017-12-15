taskkill /f /im h3control.exe
rd /q /s H3Control\bin
rd /q /s H3Control\obj
rem winrar a "C:\Users\Пользователь\Google Диск\backup\H3Control (.rar" -s -m5 -agYYYY-MM-DD,HH-MM-SS) -r
set /p Build=<build\build
set /p Version=<build\ver
for /f "delims=;" %%i in ('powershell -command "[System.DateTime]::Now.ToString(\"yyyy-MM-dd,HH-mm-ss\")"') DO set datetime=%%i
"C:\Program Files\7-Zip\7zG.exe" a -t7z -mx=9 -mfb=128 -md=128m -ms=on -xr!.git ^
  "C:\Users\Backups on Google Drive\H3Control-bin (%datetime%) %Version%.%Build%.7z" .
