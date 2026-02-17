Write-Host "=== Creating Nested Hyper-V VM ==="

New-VM -Name NestedVM -MemoryStartupBytes 1GB -Generation 2 -NoVHD -ErrorAction SilentlyContinue

Start-Sleep -Seconds 20

Write-Host "=== Collecting Process and VM Info ==="

$results = @()

Get-Process | ForEach-Object {
$results += [PSCustomObject]@{
Type = "Process"
Name = $*.ProcessName
Id   = $*.Id
}
}

Get-VM | ForEach-Object {
$results += [PSCustomObject]@{
Type = "VM"
Name = $*.Name
Version = $*.Version
}
}

$results += [PSCustomObject]@{
Type = "Message"
Name = "This is Hyper-V VM"
Id   = ""
}

$csvPath = "Z:\hyperv-output.csv"

$results | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "=== CSV Saved to File Share ==="
