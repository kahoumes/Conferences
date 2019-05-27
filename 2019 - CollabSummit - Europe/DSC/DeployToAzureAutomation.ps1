param ( 
    [parameter(Mandatory = $true)]
    [string]$TargetEnvironment
)
$DSCScriptPath                   = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "SharePoint2019.ps1"))
$ConfigDataPath                  = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "ConfigurationData-$($TargetEnvironment).psd1"))
$ConfigurationData               = Import-PowerShellDataFile $ConfigDataPath
$RGLocation                      = "westus"
$AutomationAccountName           = "CollabSummit"
$AutomationResourceGroupName     = "CollabSummit"
$ResourceGroupName               = "CS$TargetEnvironment"
$WebFrontEndVM                   = "SPWFE$ResourceGroupName"
$ApplicationVM                   = "SPAPP$ResourceGroupName"
$SearchVM                        = "SPSRC$ResourceGroupName"

Write-Output "Uploading the SharePoint Configuration into Azure Automation..."
Import-AzureRmAutomationDscConfiguration -SourcePath $DSCScriptPath -ResourceGroupName $AutomationResourceGroupName -AutomationAccountName $AutomationAccountName -Published -Force

Write-Output "Compiling the SharePoint Configuration within Azure Automation..."
Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $AutomationResourceGroupName -AutomationAccountName $AutomationAccountName -ConfigurationName "SharePoint2019" -ConfigurationData $ConfigurationData

Write-Output "Registering the WFE SharePoint Server with Azure Automation"
Register-AzureRmAutomationDscNode -AzureVMResourceGroup $ResourceGroupName -AzureVMName $WebFrontEndVM -AzureVMLocation $RGLocation -NodeConfigurationName "SharePoint2019.$($WebFrontEndVM)" -ActionAfterReboot ContinueConfiguration -RebootNodeIfNeeded $true -AutomationAccountName $AutomationAccountName -ResourceGroupName $AutomationResourceGroupName

Write-Output "Registering the APP SharePoint Server with Azure Automation"
Register-AzureRmAutomationDscNode -AzureVMResourceGroup $ResourceGroupName -AzureVMName $ApplicationVM -AzureVMLocation $RGLocation -NodeConfigurationName "SharePoint2019.$($WebFrontEndVM)" -ActionAfterReboot ContinueConfiguration -RebootNodeIfNeeded $true -AutomationAccountName $AutomationAccountName -ResourceGroupName $AutomationResourceGroupName

Write-Output "Registering the SRC SharePoint Server with Azure Automation"
Register-AzureRmAutomationDscNode -AzureVMResourceGroup $ResourceGroupName -AzureVMName $SearchVM -AzureVMLocation $RGLocation -NodeConfigurationName "SharePoint2019.$($WebFrontEndVM)" -ActionAfterReboot ContinueConfiguration -RebootNodeIfNeeded $true -AutomationAccountName $AutomationAccountName -ResourceGroupName $AutomationResourceGroupName
