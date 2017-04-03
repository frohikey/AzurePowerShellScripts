# AzurePowerShellScripts
List of small scripts for managing resources in Azure.

## create-net-website

`.\create-net-website.ps1 -WebSiteName "myWebSiteName" [-ServicePlan] "ServicePlan" [-Location] "Location"`

Creates a Windows Azure Website with settings:
- Always on: true
- PHP: off
- 32bit: true

Create Application Insights.

Add app settings:
- WEBSITE_TIME_ZONE = Central Europe Standard Time
- APPINSIGHTS_INSTRUMENTATIONKEY = Application Insights Instrumentation Key 

## create-php-website

`.\create-php-website.ps1 -WebSiteName "myWebSiteName" [-ServicePlan] "ServicePlan" [-Location] "Location"`

Creates a Windows Azure Website with settings:
- Always on: true
- 32bit: true

Add app settings:
- WEBSITE_TIME_ZONE = Central Europe Standard Time 

## add-website-hostname

`.\add-website-hostname.ps1 -WebSiteName "myWebSiteName" -HostName "www.goto10.cz"`

Add a new hostname for a given Azure Website.

## set-path

`.\set-path.ps1`

Modify PATH environment settings.

_Must be run as administrator!_