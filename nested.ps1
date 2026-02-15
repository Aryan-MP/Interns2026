# Install Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

# Create folder
New-Item -Path "C:\NestedVMs" -ItemType Directory -Force

# Create virtual switch
New-VMSwitch -Name "InternalSwitch" -SwitchType Internal

# Create Inner VM
New-VM -Name "InnerVM" `
-MemoryStartupBytes 2GB `
-Generation 2 `
-NewVHDPath "C:\NestedVMs\InnerVM.vhdx" `
-NewVHDSizeBytes 40GB `
-SwitchName "InternalSwitch"

Start-VM -Name "InnerVM"

Start-Sleep -Seconds 20

# Run script inside Inner VM
Invoke-Command -VMName "InnerVM" -ScriptBlock {
    $date = Get-Date
    "Hello from Inner VM at $date" | Out-File "C:\result.txt"
}

# Copy result to Outer VM
Copy-VMFile -Name "InnerVM" `
-SourcePath "C:\result.txt" `
-DestinationPath "C:\OuterResult.txt" `
-FileSource Guest `
-CreateFullPath