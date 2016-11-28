# AzurePowerShellScripts
List of small scripts for managing resources in Azure.

## create-website

`.\create-website.ps1 -WebSiteName "myWebSiteName" [-ServicePlan] "ServicePlan" [-Location] "Location"`

Creates a Windows Azure Website with settings:
- Always on: true
- PHP: off
- 64bit: true

Create Application Insights.

Add app settings:
- WEBSITE_TIME_ZONE = Central Europe Standard Time
- APPINSIGHTS_INSTRUMENTATIONKEY = Application Insights Instrumentation Key 