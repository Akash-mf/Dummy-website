# Convert JPG images to WebP format
$imageDir = Join-Path $PSScriptRoot 'Images\products'

# Check if cwebp is available (you need to install WebP utilities first)
if (!(Get-Command cwebp -ErrorAction SilentlyContinue)) {
    Write-Host "WebP utilities not found. Please install WebP utilities first:" -ForegroundColor Red
    Write-Host "1. Download from: https://developers.google.com/speed/webp/download" -ForegroundColor Yellow
    Write-Host "2. Add to system PATH" -ForegroundColor Yellow
    Write-Host "3. Run this script again" -ForegroundColor Yellow
    exit
}

# Convert each JPG to WebP
Get-ChildItem -Path $imageDir -Filter "*.jpg" | ForEach-Object {
    $webpPath = Join-Path $imageDir ($_.BaseName + ".webp")
    Write-Host "Converting $($_.Name) to WebP..." -ForegroundColor Cyan
    & cwebp -q 80 $_.FullName -o $webpPath
    Write-Host "Created: $webpPath" -ForegroundColor Green
}

Write-Host "`nConversion complete! Update your HTML to use <picture> tags for WebP support." -ForegroundColor Green