<#
.SYNOPSIS
    Set Path variable.
    Please, run as Administrator.
.DESCRIPTION 
   Creates a new website and a new Application Insight.  
.EXAMPLE
   .\set-path.ps1 
#>

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";c:\Data\AzurePowerShellScripts", [EnvironmentVariableTarget]::Machine)

Write-Host "Complete!"


