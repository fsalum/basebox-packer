@echo off

setlocal EnableExtensions EnableDelayedExpansion

if "%PROVISIONER%" == "puppet" (
  :: If TEMP is not defined in this shell instance, define it ourselves
  if not defined TEMP set TEMP=%USERPROFILE%\AppData\Local\Temp
  set REMOTE_SOURCE_MSI_URL=https://downloads.puppetlabs.com/windows/puppet-3.4.3.msi
  set LOCAL_DESTINATION_MSI_PATH=!TEMP!\puppet-client-latest.msi
  set FALLBACK_QUERY_STRING=?DownloadContext=PowerShell

  :: Always latest, for now
  echo ==^> Downloading Puppet client %PROVISIONER_VERSION%
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('!REMOTE_SOURCE_MSI_URL!!FALLBACK_QUERY_STRING!', '"!LOCAL_DESTINATION_MSI_PATH!"')" <NUL

  echo ==^> Installing Puppet client %PROVISIONER_VERSION%
  msiexec /qn /i "!LOCAL_DESTINATION_MSI_PATH!" PUPPET_MASTER_SERVER=puppet.singlevm.local PUPPET_AGENT_CERTNAME=vagrant-win2008r2-standard.singlevm.local

  echo ==^> Cleaning up Puppet install
  del /F /Q "!LOCAL_DESTINATION_MSI_PATH!"
) else (
  echo ==^> Building box without a provisioner."
)
