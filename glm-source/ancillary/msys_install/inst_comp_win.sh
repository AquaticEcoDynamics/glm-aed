# #!/bin/bash
#
if [[ $(sfc 2>&1 | tr -d '\0') =~ SCANNOW ]]; then
  echo Installing ....
else
  echo This must be run as Administrator
  exit 1
fi

# for vs19
VSV="16"
#for vs22
#VSV="17"

curl -SL --ssl-no-revoke --output vs_community_2019.exe https://aka.ms/vs/$VSV/release/vs_community.exe
./vs_community_2019.exe --quiet --norestart --wait --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended
#
curl -SL --ssl-no-revoke --output w_fortran-compiler_p_2024.0.2.27_offline.exe https://registrationcenter-download.intel.com/akdlm/irc_nas/19107/w_fortran-compiler_p_2024.0.2.27_offline.exe
mkdir tmp
./w_fortran-compiler_p_2024.0.2.27_offline.exe -s -f tmp -a --silent --cli --action install --eula accept

