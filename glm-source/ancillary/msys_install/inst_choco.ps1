@echo off
REM 
REM https://green.cloud/docs/how-to-install-chocolatey-on-windows-server-2012-2019/
REM 
REM Open an administrative PowerShell prompt (right-click Start -> Windows PowerShell (administrator)) and type the following command:

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

REM 
REM Basic Chocolatey Commands
REM =========================
REM 
REM Now let's review some of the basic commands for using Choco. Choco commands can be used in both the
REM Windows cmd shell and in PowerShell.
REM 
REM There are hundreds of packages that you can browse on the Chocolatey website https://chocolatey.org/packages or by running:
REM 
REM     choco list
REM 
REM To install a package, open an administrative command prompt or PowerShell session and type the following command:
REM 
REM     choco install  -y
REM 
REM For example:
REM 
REM     choco install firefox -y
REM 
REM 
REM For our purposes :
REM 
          choco install -y make
          choco install -y mingw
          choco install -y git
          choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
REM       choco install -y pkgconfiglite

