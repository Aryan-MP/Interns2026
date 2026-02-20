#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Full Developer Environment Setup Script
.DESCRIPTION
    - Installs Chocolatey
    - Installs VSCode, Power BI Desktop, Docker Desktop
    - Installs VSCode Extensions (PowerShell, ARM Tools, Docker, Azure, etc.)
    - Creates a Logon Scheduled Task to finalize per-user setup (extensions, settings)
.NOTES
    Run this script as Administrator
    Author: DevOps Setup Script
    Version: 1.0
#>

# ============================================================
# CONFIGURATION — Edit these as needed
# ============================================================
$LogFile       = "C:\Logs\DevSetup\setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$LogonTaskName = "DevEnv-UserSetup"

# VSCode Extensions to install (per-user, handled in logon task)
$VSCodeExtensions = @(
    "ms-vscode.powershell",              # PowerShell
    "msazurermtools.azurerm-vscode-tools", # ARM Templates
    "ms-azuretools.vscode-docker",       # Docker
    "ms-azure-devops.azure-pipelines",   # Azure Pipelines
    "ms-vscode.azure-account",           # Azure Account
    "ms-azuretools.vscode-azureresourcegroups", # Azure Resources
    "hashicorp.terraform",               # Terraform
    "redhat.vscode-yaml",                # YAML
    "ms-vscode-remote.remote-containers",# Dev Containers
    "eamodio.gitlens",                   # GitLens
    "esbenp.prettier-vscode",            # Prettier
    "streetsidesoftware.code-spell-checker" # Spell Checker
)

# Chocolatey packages to install
$ChocoPackages = @(
    @{ Name = "vscode";          DisplayName = "Visual Studio Code"  },
    @{ Name = "powerbi";         DisplayName = "Power BI Desktop"    },
    @{ Name = "docker-desktop";  DisplayName = "Docker Desktop"      },
    @{ Name = "git";             DisplayName = "Git"                 },
    @{ Name = "powershell-core"; DisplayName = "PowerShell 7+"       },
    @{ Name = "azure-cli";       DisplayName = "Azure CLI"           }
)

# ============================================================
# LOGGING FUNCTIONS
# ============================================================
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR","SUCCESS")][string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry  = "[$timestamp] [$Level] $Message"

    # Console color output
    switch ($Level) {
        "INFO"    { Write-Host $logEntry -ForegroundColor Cyan    }
        "WARN"    { Write-Host $logEntry -ForegroundColor Yellow  }
        "ERROR"   { Write-Host $logEntry -ForegroundColor Red     }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green   }
    }

    # Write to log file
    Add-Content -Path $LogFile -Value $logEntry
}

function Write-Banner {
    param([string]$Title)
    $line = "=" * 60
    Write-Host ""
    Write-Host $line              -ForegroundColor Magenta
    Write-Host "  $Title"         -ForegroundColor Magenta
    Write-Host $line              -ForegroundColor Magenta
    Write-Host ""
    Add-Content -Path $LogFile -Value "`n$line`n  $Title`n$line"
}

# ============================================================
# INITIALIZE LOG DIRECTORY
# ============================================================
function Initialize-LogDirectory {
    $logDir = Split-Path $LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    Write-Log "Log file initialized at: $LogFile" "INFO"
}

# ============================================================
# STEP 1 — INSTALL CHOCOLATEY
# ============================================================
function Install-Chocolatey {
    Write-Banner "STEP 1: Installing Chocolatey"

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Log "Chocolatey is already installed. Version: $(choco --version)" "SUCCESS"
        return
    }

    try {
        Write-Log "Installing Chocolatey..." "INFO"

        # Set execution policy for this process
        Set-ExecutionPolicy Bypass -Scope Process -Force

        # Set TLS 1.2
        [System.Net.ServicePointManager]::SecurityProtocol = `
            [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

        # Run the official Chocolatey install script
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString(
            'https://community.chocolatey.org/install.ps1'
        ))

        # Refresh environment so 'choco' is available in this session
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("Path","User")

        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Log "Chocolatey installed successfully. Version: $(choco --version)" "SUCCESS"
        } else {
            throw "Chocolatey command not found after installation."
        }

    } catch {
        Write-Log "Failed to install Chocolatey: $_" "ERROR"
        exit 1
    }
}

# ============================================================
# STEP 2 — INSTALL APPLICATIONS VIA CHOCOLATEY
# ============================================================
function Install-Applications {
    Write-Banner "STEP 2: Installing Applications via Chocolatey"

    foreach ($pkg in $ChocoPackages) {
        Write-Log "Installing $($pkg.DisplayName) [$($pkg.Name)]..." "INFO"
        try {
            $result = choco install $pkg.Name -y --no-progress 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "$($pkg.DisplayName) installed successfully." "SUCCESS"
            } else {
                Write-Log "$($pkg.DisplayName) install returned exit code $LASTEXITCODE. Details: $result" "WARN"
            }
        } catch {
            Write-Log "Error installing $($pkg.DisplayName): $_" "ERROR"
        }
    }

    # Refresh PATH after all installs
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")

    Write-Log "All application installations attempted." "INFO"
}

# ============================================================
# STEP 3 — INSTALL VSCODE EXTENSIONS (System-wide attempt)
# ============================================================
function Install-VSCodeExtensions {
    Write-Banner "STEP 3: Installing VSCode Extensions"

    # Find code.exe
    $codePaths = @(
        "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd",
        "$env:LocalAppData\Programs\Microsoft VS Code\bin\code.cmd",
        "code"  # fallback if in PATH
    )

    $codeCli = $null
    foreach ($path in $codePaths) {
        if (Get-Command $path -ErrorAction SilentlyContinue) {
            $codeCli = $path
            break
        }
    }

    if (-not $codeCli) {
        Write-Log "VSCode CLI (code) not found. Extensions will be installed via Logon Task." "WARN"
        return
    }

    Write-Log "Found VSCode CLI: $codeCli" "INFO"

    foreach ($ext in $VSCodeExtensions) {
        Write-Log "Installing extension: $ext" "INFO"
        try {
            & $codeCli --install-extension $ext --force 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Extension installed: $ext" "SUCCESS"
            } else {
                Write-Log "Extension may have failed (exit $LASTEXITCODE): $ext" "WARN"
            }
        } catch {
            Write-Log "Error installing extension $ext : $_" "ERROR"
        }
    }
}

# ============================================================
# STEP 4 — CREATE VSCODE SETTINGS FILE
# ============================================================
function Set-VSCodeSettings {
    Write-Banner "STEP 4: Configuring VSCode Default Settings"

    # Write a default settings.json to the machine-level location
    # (Per-user settings will be in $env:APPDATA\Code\User\settings.json)
    $settingsTemplate = @'
{
    "editor.fontSize": 14,
    "editor.tabSize": 4,
    "editor.formatOnSave": true,
    "editor.wordWrap": "on",
    "editor.minimap.enabled": true,
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "workbench.colorTheme": "Default Dark+",
    "powershell.integratedConsole.showOnStartup": false,
    "powershell.scriptAnalysis.enable": true,
    "docker.showStartPage": false,
    "git.autofetch": true,
    "git.confirmSync": false,
    "[json]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[powershell]": {
        "editor.defaultFormatter": "ms-vscode.powershell"
    },
    "azurerm-vscode-tools.checkForContextErrors": true,
    "extensions.autoUpdate": true
}
'@

    # Save template settings to a shared location for the logon task to copy
    $templatePath = "C:\DevSetup\vscode-settings-template.json"
    $templateDir  = Split-Path $templatePath -Parent

    if (-not (Test-Path $templateDir)) {
        New-Item -ItemType Directory -Path $templateDir -Force | Out-Null
    }

    $settingsTemplate | Out-File -FilePath $templatePath -Encoding UTF8 -Force
    Write-Log "VSCode settings template saved to: $templatePath" "SUCCESS"
}

# ============================================================
# STEP 5 — CREATE LOGON SCHEDULED TASK
#          Runs once per user to install extensions + apply settings
# ============================================================
function Register-LogonTask {
    Write-Banner "STEP 5: Registering Logon Scheduled Task"

    # The per-user script content (embedded inline)
    $userScriptContent = @"
# ================================================================
# Per-User Logon Setup Script — DevEnvironment
# Runs once at first logon to install VSCode extensions & settings
# ================================================================

`$LogFile = "`$env:APPDATA\DevSetup\logon_setup.log"
`$LockFile = "`$env:APPDATA\DevSetup\setup.done"

function Write-ULog {
    param([string]`$Msg, [string]`$Level = "INFO")
    `$entry = "[`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [`$Level] `$Msg"
    Write-Host `$entry
    Add-Content -Path `$LogFile -Value `$entry -ErrorAction SilentlyContinue
}

# Run only once per user
if (Test-Path `$LockFile) {
    Write-ULog "Setup already completed for this user. Exiting." "INFO"
    exit 0
}

# Create log dir
`$logDir = Split-Path `$LogFile -Parent
if (-not (Test-Path `$logDir)) { New-Item -ItemType Directory `$logDir -Force | Out-Null }

Write-ULog "===== Starting Per-User DevEnvironment Setup =====" "INFO"

# ── Install VSCode Extensions ────────────────────────────────
`$extensions = @(
    "ms-vscode.powershell",
    "msazurermtools.azurerm-vscode-tools",
    "ms-azuretools.vscode-docker",
    "ms-azure-devops.azure-pipelines",
    "ms-vscode.azure-account",
    "ms-azuretools.vscode-azureresourcegroups",
    "hashicorp.terraform",
    "redhat.vscode-yaml",
    "ms-vscode-remote.remote-containers",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "streetsidesoftware.code-spell-checker"
)

`$codePaths = @(
    "`$env:ProgramFiles\Microsoft VS Code\bin\code.cmd",
    "`$env:LocalAppData\Programs\Microsoft VS Code\bin\code.cmd",
    "code"
)

`$codeCli = `$null
foreach (`$p in `$codePaths) {
    if (Get-Command `$p -ErrorAction SilentlyContinue) { `$codeCli = `$p; break }
}

if (`$codeCli) {
    Write-ULog "Installing VSCode extensions using: `$codeCli" "INFO"
    foreach (`$ext in `$extensions) {
        Write-ULog "Installing extension: `$ext" "INFO"
        & `$codeCli --install-extension `$ext --force 2>&1 | Out-Null
        if (`$LASTEXITCODE -eq 0) { Write-ULog "OK: `$ext" "SUCCESS" }
        else { Write-ULog "WARN: `$ext (exit `$LASTEXITCODE)" "WARN" }
    }
} else {
    Write-ULog "VSCode CLI not found. Skipping extension install." "WARN"
}

# ── Apply VSCode Settings ────────────────────────────────────
`$settingsTemplate = "C:\DevSetup\vscode-settings-template.json"
`$userSettingsDir  = "`$env:APPDATA\Code\User"
`$userSettingsFile = "`$userSettingsDir\settings.json"

if (Test-Path `$settingsTemplate) {
    if (-not (Test-Path `$userSettingsDir)) {
        New-Item -ItemType Directory `$userSettingsDir -Force | Out-Null
    }
    if (-not (Test-Path `$userSettingsFile)) {
        Copy-Item `$settingsTemplate `$userSettingsFile -Force
        Write-ULog "VSCode settings applied from template." "SUCCESS"
    } else {
        Write-ULog "VSCode settings.json already exists — skipping to preserve user settings." "WARN"
    }
} else {
    Write-ULog "Settings template not found at `$settingsTemplate." "WARN"
}

# ── Docker Desktop — start if installed ─────────────────────
`$dockerPath = "`$env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
if (Test-Path `$dockerPath) {
    Write-ULog "Docker Desktop found. It will start on next login automatically." "INFO"
} else {
    Write-ULog "Docker Desktop not found at expected path." "WARN"
}

# ── Mark setup as complete ───────────────────────────────────
"Setup completed: `$(Get-Date)" | Out-File `$LockFile -Force
Write-ULog "===== Per-User Setup Complete =====" "SUCCESS"
"@

    # Save the per-user logon script to a system location
    $logonScriptDir  = "C:\DevSetup"
    $logonScriptPath = "$logonScriptDir\UserLogonSetup.ps1"

    if (-not (Test-Path $logonScriptDir)) {
        New-Item -ItemType Directory -Path $logonScriptDir -Force | Out-Null
    }

    $userScriptContent | Out-File -FilePath $logonScriptPath -Encoding UTF8 -Force
    Write-Log "Logon script saved to: $logonScriptPath" "INFO"

    # ── Register the Scheduled Task ──────────────────────────
    $action  = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$logonScriptPath`""

    $trigger = New-ScheduledTaskTrigger -AtLogOn

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit (New-TimeSpan -Minutes 30)

    $principal = New-ScheduledTaskPrincipal `
        -GroupId "BUILTIN\Users" `
        -RunLevel Limited

    # Remove existing task if present
    if (Get-ScheduledTask -TaskName $LogonTaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $LogonTaskName -Confirm:$false
        Write-Log "Removed existing scheduled task: $LogonTaskName" "WARN"
    }

    Register-ScheduledTask `
        -TaskName  $LogonTaskName `
        -Action    $action `
        -Trigger   $trigger `
        -Settings  $settings `
        -Principal $principal `
        -Description "Installs VSCode extensions and applies dev settings on first user logon." `
        | Out-Null

    Write-Log "Scheduled Task '$LogonTaskName' registered successfully." "SUCCESS"
    Write-Log "Task will run for ALL users at logon (once per user via lock file)." "INFO"
}

# ============================================================
# STEP 6 — VERIFY INSTALLATIONS
# ============================================================
function Test-Installations {
    Write-Banner "STEP 6: Verifying Installations"

    $checks = @(
        @{ Name = "Chocolatey";       Command = "choco";               Args = "--version"  },
        @{ Name = "Git";              Command = "git";                  Args = "--version"  },
        @{ Name = "Azure CLI";        Command = "az";                   Args = "--version"  },
        @{ Name = "PowerShell Core";  Command = "pwsh";                 Args = "--version"  },
        @{ Name = "VSCode";           Command = "code";                 Args = "--version"  },
        @{ Name = "Docker";           Command = "docker";               Args = "--version"  }
    )

    foreach ($check in $checks) {
        try {
            $output = & $check.Command $check.Args 2>&1 | Select-Object -First 1
            Write-Log "$($check.Name): $output" "SUCCESS"
        } catch {
            Write-Log "$($check.Name): NOT FOUND or not in PATH" "WARN"
        }
    }

    # Check scheduled task
    $task = Get-ScheduledTask -TaskName $LogonTaskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Log "Scheduled Task '$LogonTaskName': $($task.State)" "SUCCESS"
    } else {
        Write-Log "Scheduled Task '$LogonTaskName': NOT FOUND" "ERROR"
    }
}

# ============================================================
# MAIN EXECUTION
# ============================================================
function Main {
    Write-Banner "Developer Environment Setup — Starting"
    Write-Log "Running as: $env:USERNAME on $env:COMPUTERNAME" "INFO"
    Write-Log "PowerShell Version: $($PSVersionTable.PSVersion)" "INFO"

    Initialize-LogDirectory
    Install-Chocolatey
    Install-Applications
    Install-VSCodeExtensions
    Set-VSCodeSettings
    Register-LogonTask
    Test-Installations

    Write-Banner "Setup Complete!"
    Write-Log "Log saved to: $LogFile" "SUCCESS"
    Write-Log "NEXT STEPS:" "INFO"
    Write-Log "  1. Reboot the machine (recommended for Docker Desktop)" "INFO"
    Write-Log "  2. Log on as any user — VSCode extensions will auto-install on first logon" "INFO"
    Write-Log "  3. Open Docker Desktop and complete the first-run setup" "INFO"
    Write-Log "  4. Sign in to Azure CLI: az login" "INFO"
}

# Run
Main