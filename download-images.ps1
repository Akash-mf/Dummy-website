# download-images.ps1
# Place this file in the website root (d:\Dummy website) and run it from PowerShell.
# What it does:
#  - Ensures Images\products directory exists
#  - Removes any existing .svg placeholders
#  - Downloads representative JPGs from Unsplash Source into Images\products with filenames that match index.html

$prodDir = Join-Path $PSScriptRoot 'Images\products'
if (!(Test-Path $prodDir)) {
    New-Item -ItemType Directory -Path $prodDir | Out-Null
}

# Remove SVG placeholders if any
Get-ChildItem -Path $prodDir -Filter '*.svg' -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    try { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop; Write-Host "Removed: $($_.Name)" -ForegroundColor Green }
    catch { Write-Warning "Could not remove $($_.Name): $_" }
}

# Mapping of desired filenames => Unsplash Source queries (random photo matching the query)
$images = @{
    "hero-1.jpg" = "https://source.unsplash.com/1200x800/?electronics,product"
    "hero-2.jpg" = "https://source.unsplash.com/1200x800/?industry,machine"
    "hero-3.jpg" = "https://source.unsplash.com/1200x800/?tools,workshop"
    "hero-bg.jpg" = "https://source.unsplash.com/1600x900/?factory,background"

    "smart-gadgets.jpg" = "https://source.unsplash.com/800x600/?smart,gadget"
    "modern-kitchen.jpg" = "https://source.unsplash.com/800x600/?kitchen,modern"
    "kitchen-utilities.jpg" = "https://source.unsplash.com/800x600/?kitchen,utensils"
    "gym-equipment.jpg" = "https://source.unsplash.com/800x600/?gym,fitness"
    "professional-tools.jpg" = "https://source.unsplash.com/800x600/?tools,workshop"
    "wire-trays.jpg" = "https://source.unsplash.com/800x600/?wire,trays"
    "child-utilities.jpg" = "https://source.unsplash.com/800x600/?child,toys"
    "wall-decor.jpg" = "https://source.unsplash.com/800x600/?wall,decor"
    "common-utilities.jpg" = "https://source.unsplash.com/800x600/?home,utilities"
    "electronic-gadgets.jpg" = "https://source.unsplash.com/800x600/?electronics,gadgets"

    "construction-machine.jpg" = "https://source.unsplash.com/800x600/?construction,machine"
    "bending-machine.jpg" = "https://source.unsplash.com/800x600/?metal,bending"
    "cutting-machine.jpg" = "https://source.unsplash.com/800x600/?cutting,machinery"
    "shearing-machine.jpg" = "https://source.unsplash.com/800x600/?shear,metal"
    "polishing-machine.jpg" = "https://source.unsplash.com/800x600/?polishing,machine"
    "iron-worker.jpg" = "https://source.unsplash.com/800x600/?ironworker,machine"
    "specialized-machine.jpg" = "https://source.unsplash.com/800x600/?industrial,specialized"
    "industrial-machine.jpg" = "https://source.unsplash.com/800x600/?industrial,machinery"
}

foreach ($name in $images.Keys) {
    $url = $images[$name]
    $out = Join-Path $prodDir $name
    Write-Host "Downloading $name from $url" -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $out -ErrorAction Stop
        Write-Host "Saved: $out" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to download $name: $_"
    }
}

Write-Host "\nDownload completed. Files in $prodDir:" -ForegroundColor Yellow
Get-ChildItem -Path $prodDir | Select-Object Name,Length | Format-Table -AutoSize

Write-Host "\nNotes:`n- These images are fetched from the Unsplash Source endpoint (random images matching the query).`n- If you want fixed, curated photos (specific Unsplash IDs), tell me and I will update the script with exact URLs." -ForegroundColor Magenta
