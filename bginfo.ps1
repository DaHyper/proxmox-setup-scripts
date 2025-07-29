# This script assumes it is running *after* extraction from bginfo.zip
# So all files (Bginfo.exe, config.bgi, setup-bginfo.ps1) are in the same folder

# Get the current script folder (should be where files extracted)
$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
$extractPath = "C:\BGInfo"

# Create destination folder if missing
if (-not (Test-Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath | Out-Null
}

# Copy all files from current folder (where script runs) to C:\BGInfo
Get-ChildItem -Path $scriptFolder -File | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $extractPath -Force
}

$bginfoExe = Join-Path $extractPath "Bginfo.exe"
$configFile = Join-Path $extractPath "config.bgi"
$taskName = "BginfoAutoUpdate"

# Setup Task Scheduler task
$action = New-ScheduledTaskAction -Execute $bginfoExe -Argument "`"$configFile`" /timer:0 /nolicprompt /silent"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId "BUILTIN\Users" -LogonType Interactive -RunLevel LeastPrivilege

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force
    Write-Host "Scheduled task '$taskName' created successfully."
} catch {
    Write-Warning "Failed to create scheduled task: $_"
}

# Cleanup: Remove script itself from C:\BGInfo folder after setup
$scriptName = Split-Path -Leaf $MyInvocation.MyCommand.Definition
$scriptCopyPath = Join-Path $extractPath $scriptName

if (Test-Path $scriptCopyPath) {
    Remove-Item -Path $scriptCopyPath -Force
    Write-Host "Removed setup script from $extractPath."
}

Write-Host "Setup complete. Bginfo installed in $extractPath and scheduled."
