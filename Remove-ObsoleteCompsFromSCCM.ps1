# Simple script to:
#	- Find computers that are in SCCM but not in Active Directory
#	- Remove those computers from SCCM
# sami.lanu@tuni.fi

# Active Directory OU 
$OU = "OU=Accounts, OU=Computer, DC=your, DC=domain, DC=com"
$ADcomps = Get-ADComputer -Filter * -SearchBase $OU | select -ExpandProperty name

# Get all computers from SCCM collection
$CMSite = "CMSITECODE:"
$Collection = "CMComputerCollection"
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
Set-Location $CMSite
$CMComps = Get-CMDevice -CollectionName $Collection | select -ExpandProperty name

# Find computers that are in SCCM but not in AD
$Result = $CMcomps | where-object {$ADComps -notcontains $_}
write-host "Computers in CM but not found from AD: $Result"

# Remove computers from SCCM
foreach ($i in $Result) { remove-cmdevice -DeviceName $i -Force }