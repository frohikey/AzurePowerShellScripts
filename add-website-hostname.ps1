<#
.SYNOPSIS
    Add website hostname.    
.DESCRIPTION 
    Add website hostname.
.EXAMPLE
   .\add-website-hostname.ps1 -WebSiteName "myWebSiteName" -HostName "www.goto10.cz" 
#>
param(
    [CmdletBinding(SupportsShouldProcess=$true)]
         
    # The webSite Name you want to create
    [Parameter(Mandatory = $true)] 
    [string]$WebSiteName,
    
    # Host name
    [Parameter(Mandatory = $true)]
    [string]$HostName         
    )

#$VerbosePreference = "Continue"

# Check if Windows Azure Powershell is avaiable
if ((Get-Module -ListAvailable Azure) -eq $null)
{
    throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools"
}

# Check if there is already a login session in Azure Powershell
Try
{
    $ctx = Get-AzureRmContext -ErrorAction Continue
}
Catch [System.Management.Automation.PSInvalidOperationException]
{
    Login-AzureRmAccount
}

# Find the website
$website = Get-AzureWebsite | Where-Object {$_.Name -eq $WebSiteName }

if ($website -eq $null) 
{   
    throw "Website '$WebSiteName' not found."
}                    
else 
{        
    $newHosts = [System.Collections.ArrayList]@()
    $hosts = $website.HostNames
    
    Write-Host "Current hostnames for website '$($WebSiteName)':"

    foreach($h in $hosts) {
        # We need to remove "default" $WebSiteName.azurewebsites.net host or 
        # setting of HostNames will fail with no result!
        if (!$h.EndsWith('.azurewebsites.net')) {        
            $n = $newHosts.Add($h)
        }
        $n++;
        Write-Host "$n. $h"
    }

    $n = $newHosts.Add($HostName)
    $n++;
    Write-Host "Adding $n. hostname: $HostName"
    
    Set-AzureWebsite -Name $WebSiteName -HostNames $newHosts
    
}

Write-Host "Complete!"


