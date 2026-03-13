$adocFile = "OFTP2 Onboarding Package - Project Proposal.adoc"
$pdfFile  = "OFTP2_Onboarding_Proposal.pdf"
$docsDir  = $PSScriptRoot

Write-Host "Watching '$adocFile' for changes... (Ctrl+C to stop)" -ForegroundColor Cyan

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path   = $docsDir
$watcher.Filter = $adocFile
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite

function Rebuild {
    Write-Host ('[{0}] Change detected, regenerating PDF...' -f (Get-Date -Format 'HH:mm:ss')) -ForegroundColor Yellow
    $version = & git -C $docsDir describe --tags --always 2>$null
    if (-not $version) { $version = 'dev' }
    $date = (Get-Date -Format 'yyyy-MM-dd')
    docker run --rm `
        -v "${docsDir}:/documents" `
        asciidoctor/docker-asciidoctor `
        asciidoctor-pdf -a data-uri -a pdf-theme=theme.yml -a revnumber=$version -a revdate=$date -o $pdfFile $adocFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host ("[{0}] PDF updated: $pdfFile" -f (Get-Date -Format "HH:mm:ss")) -ForegroundColor Green
    } else {
        Write-Host ("[{0}] ERROR: PDF generation failed." -f (Get-Date -Format "HH:mm:ss")) -ForegroundColor Red
    }
}

# Debounce: wait 1 second after the last change before rebuilding
$lastEvent = [datetime]::MinValue
$action = {
    $now = [datetime]::Now
    if (($now - $script:lastEvent).TotalSeconds -gt 1) {
        $script:lastEvent = $now
        Rebuild
    }
}

$watcher.EnableRaisingEvents = $true
Register-ObjectEvent $watcher Changed -Action $action | Out-Null

# Run once immediately on start
Rebuild

try {
    while ($true) { Start-Sleep -Seconds 1 }
} finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
}
