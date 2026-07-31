@echo off

REM # for vs19
REM VSV="16"
REM #for vs22
REM #VSV="17"
REM 
REM curl -SL --ssl-no-revoke --output vs_community_2019.exe https://aka.ms/vs/$VSV/release/vs_community.exe

.\vs_community_2019.exe --quiet --norestart --wait --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended

REM curl -SL --ssl-no-revoke --output w_fortran-compiler_p_2024.0.2.27_offline.exe https://registrationcenter-download.intel.com/akdlm/irc_nas/19107/w_fortran-compiler_p_2024.0.2.27_offline.exe

mkdir tmp
.\w_fortran-compiler_p_2024.0.2.27_offline.exe -s -f tmp -a --silent --cli --action install --eula accept

