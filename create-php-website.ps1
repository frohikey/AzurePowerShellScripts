<#
.SYNOPSIS
    Creates a Windows Azure Website (PHP) with settings:
    - Always on: true    
    - 64bit: true

    Add app settings:
    WEBSITE_TIME_ZONE = Central Europe Standard Time
.DESCRIPTION 
   Creates a new PHP website.  
.EXAMPLE
   .\create-php-website.ps1 -WebSiteName "myWebSiteName" [-ServicePlan] "ServicePlan" [-Location] "Location" 
#>
param(
    [CmdletBinding(SupportsShouldProcess=$true)]
         
    # The webSite name you want to create
    [Parameter(Mandatory = $true)] 
    [string]$WebSiteName,
    
    # Resource group name
    [string]$ResourceGroup = "Default-Web-WestEurope",
     
    # Service plan
    [string]$ServicePlan = "CellONE",

    # Location
    [string]$Location = "West Europe"
    )

#$VerbosePreference = "Continue"

# Check if Windows Azure Powershell is avaiable
if ((Get-Module -ListAvailable Azure) -eq $null)
{
    throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools"
}

# Check if there is already a login session in Azure Powershell
try
{
    $ctx = Get-AzureRmContext -ErrorAction Continue
}
catch [System.Management.Automation.PSInvalidOperationException]
{
    Login-AzureRmAccount
}

# Create the website 
$website = Get-AzureWebsite | Where-Object {$_.Name -eq $WebSiteName }

if ($website -eq $null) 
{   
    Write-Host "Testing website name '$WebSiteName'"
    $test = Test-AzureName -Website $WebSiteName

    if ($test -eq $true)
    {
        throw "Website name '$WebSiteName' is not available."
    }    
    
    Write-Host "Creating website '$WebSiteName' in '$ResourceGroup' for '$ServicePlan'." 
    $website = New-AzureRMWebApp -ResourceGroupName $ResourceGroup -Name $WebSiteName -Location $Location -AppServicePlan $ServicePlan    
        
    Write-Host "32bit mode on"
    $website = Set-AzureRmWebApp -ResourceGroupName $ResourceGroup -Name $WebSiteName -Use32BitWorkerProcess $true
    
    Write-Host "Setting always on"
    $Properties = @{"siteConfig" = @{"AlwaysOn" = $true}}
    $website = Set-AzureRmResource -PropertyObject $Properties -ResourceGroupName $ResourceGroup -ResourceType Microsoft.Web/sites -ResourceName $WebSiteName -ApiVersion 2015-08-01 -Force    
    
    Write-Host "Adding app settings"
    $webApp = Get-AzureRmWebApp -ResourceGroupName $ResourceGroup -Name $WebSiteName 
    $appSettingList = $webApp.SiteConfig.AppSettings    
    
    $hash = @{}
    foreach ($kvp in $appSettingList) {
        $hash[$kvp.Name] = $kvp.Value        
    }

    $hash['WEBSITE_TIME_ZONE'] = "Central Europe Standard Time"    
    $website = Set-AzureRMWebApp -ResourceGroupName $ResourceGroup -Name $WebSiteName -AppSettings $hash          
}
else 
{        
    throw "Website already exists. Please try a different website name."
}

Write-Host "Complete!"
