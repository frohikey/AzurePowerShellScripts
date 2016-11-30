<#
.SYNOPSIS
    Set Path variable.
    Please, run as Administrator.
.DESCRIPTION 
   Modify PATH environment settings.
.EXAMPLE
   .\set-path.ps1 
#>

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";c:\Data\AzurePowerShellScripts", [EnvironmentVariableTarget]::Machine)

Write-Host "Complete!"
