<#
.SYNOPSIS
   Azure storage containers' stats.
.DESCRIPTION 
   List containers with stats: number/size of blobs.    
.EXAMPLE
   .\storage-containers.ps1 -ResourceGroup "myresourcegroup" -StorageAccountName "goto10"
#>
param(
    [CmdletBinding(SupportsShouldProcess=$true)]
         
    # Resource group
    [Parameter(Mandatory = $true)] 
    [string]$ResourceGroup,
    
    # Storage account name
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName
    )

$storageAccount = Get-AzureRmStorageAccount `
  -ResourceGroupName $ResourceGroup `
  -Name $StorageAccountName
$ctx = $StorageAccount.Context 

$containers = Get-AzureStorageContainer -Context $ctx

function Get-FriendlySize {
    param($Bytes)
    $sizes='Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for($i=0; ($Bytes -ge 1kb) -and 
        ($i -lt $sizes.Count); $i++) {$Bytes/=1kb}
    $N=2; if($i -eq 0) {$N=0}
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}

foreach ($srcContainer in $containers) {    
    if ($srcContainer.Name.StartsWith("$") -or $srcContainer.Name.StartsWith("azure-")) {
        continue
    }    
    
    Write-Host "$($srcContainer.Name)"    
    
    $listOfBLobs = Get-AzureStorageBlob -Container $srcContainer.Name -Context $ctx 

    $length = 0
    $number = 0
    $listOfBlobs | ForEach-Object {$length = $length + $_.Length; $number++}

    $friendlyLength = Get-FriendlySize($length)

    Write-Host "size: " $friendlyLength
    Write-Host "number: " $number
    Write-Host "------------------------------"
}
