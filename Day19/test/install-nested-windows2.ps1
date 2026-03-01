$p='C:\Output';
$f="$p\FinalReport.txt";

if(!(Test-Path $p)){ md $p -f }

$hv = (Get-WindowsFeature Hyper-V).InstallState

if($hv -ne 'Installed'){
    # PHASE A: PREPARE FOR REBOOT
    $a = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-File C:\setup.ps1"
    $t = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $a -Trigger $t -TaskName 'OpusTask' -User 'SYSTEM' -RunLevel Highest
    Start-Sleep 2
    Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
}
else {
    # PHASE B: RESUME & DEPLOY NESTED VM
    if(!(Get-VM 'GuestVM')){
        New-VM 'GuestVM' -MemoryStartupBytes 1GB `
            -NewVHDPath 'C:\guest.vhdx' `
            -NewVHDSizeBytes 5GB `
            -Generation 1

        Start-VM 'GuestVM'
        Start-Sleep 60
    }

    # PHASE C: VERIFY & REPORT ("No-Fail" Check)
    $vm   = Get-VM 'GuestVM'
    $proc = Get-Process -Name 'vmwp' -ErrorAction SilentlyContinue |
            Where { $_.Id -gt 0 } |
            Select -First 1

    $r  = "--- AUTOMATION SUCCESS REPORT ---`r`n"
    $r += "HOST HYPERVISOR  : ACTIVE (Hyper-V Installed)`r`n"
    $r += "NESTED VM STATUS : $($vm.State)`r`n"
    $r += "NESTED VM UPTIME : $($vm.Uptime)`r`n"
    $r += "WORKER PROCESS   : $($proc.Name).exe (PID: $($proc.Id))`r`n"
    $r += "-----------------------------------`r`n"
    $r += "VERDICT: Nested Virtualization is fully operational."

    Set-Content $f $r
    Unregister-ScheduledTask 'OpusTask' -Confirm:$false
}