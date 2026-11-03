# Full Essential Windows System & Developer Tool Paths
$essentialPaths = @(
    "C:\Windows\System32\WindowsPowerShell\v1.0",
    "C:\Windows\System32",
    "C:\Windows",
    "C:\Windows\System32\Wbem",
    "C:\Windows\System32\OpenSSH",
    "C:\Program Files\Git\cmd",
    "C:\Program Files\Git\bin",
    "C:\Program Files\PowerShell\7",
    "$env:LOCALAPPDATA\Programs\Git\cmd"
)

foreach ($path in $essentialPaths) {
    if (Test-Path $path) {
        if ($env:PATH -notlike "*$path*") {
            $env:PATH = "$path;" + $env:PATH
        }
    }
}

Write-Host "✅ System PATH, PowerShell, and Git Configured!" -ForegroundColor Green
Write-Host "PowerShell located at: $(where.exe powershell.exe)" -ForegroundColor Cyan
Write-Host "Git located at: $(where.exe git.exe)" -ForegroundColor Cyan

Write-Host "`n🚀 Launching Flutter App on connected mobile..." -ForegroundColor Green
flutter run
