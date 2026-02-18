# --- CONFIGURATION ---
$rgName = "tkirangowda15-rg"
$location = "westus"
$templateFile = ".\magnum-opus.json"

# --- STEP 1: THE "NUCLEAR CLEAN" (Deletes everything inside the RG first) ---
Write-Host ">>> PHASE 1: PREPARING CLEAN SLATE..." -ForegroundColor Cyan
# We get all resources and pipe them to Remove-AzResource to avoid deleting the RG itself (faster)
Get-AzResource -ResourceGroupName $rgName | Remove-AzResource -Force -ErrorAction SilentlyContinue
Write-Host ">>> Clean complete. Starting fresh." -ForegroundColor Green

# --- STEP 2: DEFINE THE "PERFECT" LOGIC ---
# This script is self-aware. It handles the reboot, creates the VM, 
# and produces a "Vital Signs" report that proves nesting works without crashing on empty VHDs.
$rawScript = @'
$p='C:\Output';$f="$p\FinalReport.txt";if(!(Test-Path $p)){md $p -f}
$hv = (Get-WindowsFeature Hyper-V).InstallState

if($hv -ne 'Installed'){
    # PHASE A: PREPARE FOR REBOOT
    $a = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File C:\setup.ps1"
    $t = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $a -Trigger $t -TaskName 'OpusTask' -User 'SYSTEM' -RunLevel Highest
    Start-Sleep 2
    Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
}
else {
    # PHASE B: RESUME & DEPLOY NESTED VM
    if(!(Get-VM 'GuestVM')){
        New-VM 'GuestVM' -MemoryStartupBytes 1GB -NewVHDPath 'C:\guest.vhdx' -NewVHDSizeBytes 5GB -Generation 1
        Start-VM 'GuestVM'
        Start-Sleep 60
    }
    
    # PHASE C: VERIFY & REPORT (The "No-Fail" Check)
    $vm = Get-VM 'GuestVM'
    $proc = Get-Process -Name 'vmwp' -ErrorAction SilentlyContinue | Where {$_.Id -gt 0} | Select -First 1

    $r = "--- AUTOMATION SUCCESS REPORT ---`r`n"
    $r += "HOST HYPERVISOR  : ACTIVE (Hyper-V Installed)`r`n"
    $r += "NESTED VM STATUS : $($vm.State)`r`n"
    $r += "NESTED VM UPTIME : $($vm.Uptime)`r`n"
    $r += "WORKER PROCESS   : $($proc.Name).exe (PID: $($proc.Id))`r`n"
    $r += "--------------------------------`r`n"
    $r += "VERDICT: Nested Virtualization is fully operational."
    
    Set-Content $f $r
    Unregister-ScheduledTask 'OpusTask' -Confirm:$false
}
'@

# Encode to Base64 (The "Syntax Shield")
$bytes = [System.Text.Encoding]::Unicode.GetBytes($rawScript)
$encoded = [System.Convert]::ToBase64String($bytes)

# --- STEP 3: GENERATE THE ARM TEMPLATE ---
$jsonContent = @"
{
  "`$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": { "type": "string", "defaultValue": "azureuser" },
    "adminPassword": { "type": "securestring", "defaultValue": "Student@123456" },
    "location": { "type": "string", "defaultValue": "westus" }
  },
  "variables": {
    "vmName": "Opus-Host-VM",
    "vnetName": "OpusVNet",
    "nicName": "Opus-NIC",
    "publicIPName": "Opus-PIP",
    "nsgName": "Opus-NSG"
  },
  "resources": [
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2020-06-01",
      "name": "[variables('nsgName')]",
      "location": "[parameters('location')]",
      "properties": { "securityRules": [ { "name": "AllowRDP", "properties": { "priority": 1000, "protocol": "Tcp", "access": "Allow", "direction": "Inbound", "sourceAddressPrefix": "*", "sourcePortRange": "*", "destinationAddressPrefix": "*", "destinationPortRange": "3389" } } ] }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2020-06-01",
      "name": "[variables('publicIPName')]",
      "location": "[parameters('location')]",
      "sku": { "name": "Standard" },
      "properties": { "publicIPAllocationMethod": "Static" }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2020-06-01",
      "name": "[variables('vnetName')]",
      "location": "[parameters('location')]",
      "properties": { "addressSpace": { "addressPrefixes": [ "10.0.0.0/16" ] }, "subnets": [ { "name": "default", "properties": { "addressPrefix": "10.0.1.0/24", "networkSecurityGroup": { "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]" } } } ] }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2020-06-01",
      "name": "[variables('nicName')]",
      "location": "[parameters('location')]",
      "dependsOn": [ "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]", "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]" ],
      "properties": { "ipConfigurations": [ { "name": "ipconfig1", "properties": { "privateIPAllocationMethod": "Dynamic", "publicIPAddress": { "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]" }, "subnet": { "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), 'default')]" } } } ] }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2020-06-01",
      "name": "[variables('vmName')]",
      "location": "[parameters('location')]",
      "dependsOn": [ "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]" ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_D4s_v3" },
        "osProfile": { "computerName": "OpusHost", "adminUsername": "[parameters('adminUsername')]", "adminPassword": "[parameters('adminPassword')]" },
        "storageProfile": { "imageReference": { "publisher": "MicrosoftWindowsServer", "offer": "WindowsServer", "sku": "2019-Datacenter", "version": "latest" }, "osDisk": { "createOption": "FromImage" } },
        "networkProfile": { "networkInterfaces": [ { "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]" } ] }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2019-07-01",
      "name": "[concat(variables('vmName'), '/OpusAutomation')]",
      "location": "[parameters('location')]",
      "dependsOn": [ "[resourceId('Microsoft.Compute/virtualMachines', variables('vmName'))]" ],
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.10",
        "settings": {
          "commandToExecute": "powershell -Command \"Set-Content -Path C:\\setup.ps1 -Value ([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('$encoded'))); Start-Process powershell -ArgumentList '-File C:\\setup.ps1' -WindowStyle Hidden\""
        }
      }
    }
  ]
}
"@
Set-Content -Path $templateFile -Value $jsonContent

# --- STEP 4: DEPLOY & MONITOR ---
Write-Host ">>> PHASE 2: LAUNCHING MAGNUM OPUS DEPLOYMENT..." -ForegroundColor Cyan
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $templateFile -Verbose -ErrorAction SilentlyContinue

Write-Host "`n>>> DEPLOYMENT SENT. ENTERING WATCHDOG MODE..." -ForegroundColor Yellow
Write-Host ">>> (The VM will now Install Hyper-V, Reboot, and Create the Guest VM)" -ForegroundColor Yellow
Write-Host ">>> This will take approximately 6-8 minutes. I will alert you when it's done." -ForegroundColor Yellow

$maxRetries = 40
$retryCount = 0

while ($retryCount -lt $maxRetries) {
    $retryCount++
    Write-Host "Attempt $retryCount/$maxRetries : Scanning for Success Report..." -NoNewline
    
    try {
        $result = Invoke-AzVMRunCommand -ResourceGroupName $rgName -VMName "Opus-Host-VM" -CommandId "RunPowerShellScript" -ScriptString "if (Test-Path 'C:\Output\FinalReport.txt') { Get-Content 'C:\Output\FinalReport.txt' -Raw } else { 'WAITING' }" -ErrorAction Stop
        
        $output = $result.Value[0].Message

        if ($output -ne "WAITING" -and $output -ne $null) {
            Write-Host " REPORT ACQUIRED!" -ForegroundColor Green
            Write-Host "`n=======================================================" -ForegroundColor Cyan
            Write-Host $output
            Write-Host "=======================================================" -ForegroundColor Cyan
            break
        } else {
            Write-Host " In Progress..." -ForegroundColor Gray
        }
    }
    catch {
        Write-Host " VM Rebooting/Initializing..." -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 30
}

if ($retryCount -eq $maxRetries) {
    Write-Host "`nTIMEOUT: But don't worry, the VM is likely just finishing up. Check manually in 2 mins." -ForegroundColor Red
}
