<#
.DESCRIPTION
Build an Azure Key Vault using Poweshell

.PARAMETER ResourceGroup
# the name of the resource group where the key vault will be deployed

.OUTPUTS
#>

# use the environment variable if a working directory is not passed in
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [Parameter(Mandatory = $true)][string]$Location,
    [Parameter(Mandatory = $true)][string]$KeyVaultName,
    [Parameter(Mandatory = $false)][switch]$EnableRbac
)

Connect-AzAccount

# create the resource group if it does not already exist
if (-Not (Get-AzResourcegroup -Name "$ResourceGroup" -ErrorAction SilentlyContinue)) {
  Write-Host "Creating Resource Group $ResourceGroup"
  New-AzResourceGroup -Name "$ResourceGroup" -Location "$Location"
} else {
  Write-Host "Resource group $ResourceGroup already exists"
}

# create the key vault if it does not already exist
if (-Not (Get-AzKeyVault -Name $KeyVaultName)) {
  Write-Host "Creating Key Vault $KeyVaultName"
  if ($EnableRbac) {
    New-AzKeyVault -Name $KeyVaultName -ResourceGroup $ResourceGroup -Location $Location -EnableRbacAuthorization $EnableRbac
  } else {
    New-AzKeyVault -Name $KeyVaultName -ResourceGroup $ResourceGroup -Location $Location
  }
} else {
  Write-Host "Key Vault $KeyVaultName already exists"
}
#Disconnect-AzAccount