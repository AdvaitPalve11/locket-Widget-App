#!/usr/bin/env pwsh
# Production Code Quality Fix Script for Locket Widget App
# Fixes the most critical production issues

Write-Host "🔧 Starting Locket Widget App Code Quality Fixes..." -ForegroundColor Green

# Get the project directory
$ProjectDir = "c:\Users\Advait\Documents\Locket\locket_widget_app"
Set-Location $ProjectDir

Write-Host "📍 Working in: $ProjectDir" -ForegroundColor Blue

# Function to replace content in files
function Fix-WithOpacity {
    param($FilePath)
    if (Test-Path $FilePath) {
        Write-Host "🔄 Fixing withOpacity in: $FilePath" -ForegroundColor Yellow
        (Get-Content $FilePath) -replace '\.withOpacity\(([0-9.]+)\)', '.withValues(alpha: $1)' | Set-Content $FilePath
    }
}

# Function to replace print statements (basic ones)
function Fix-PrintStatements {
    param($FilePath)
    if (Test-Path $FilePath) {
        Write-Host "🔄 Fixing print statements in: $FilePath" -ForegroundColor Yellow
        # Add import if not present
        $content = Get-Content $FilePath -Raw
        if ($content -notmatch "import.*app_logger\.dart") {
            $lines = Get-Content $FilePath
            $importIndex = 0
            for ($i = 0; $i -lt $lines.Length; $i++) {
                if ($lines[$i] -match "^import") {
                    $importIndex = $i + 1
                }
            }
            $lines = $lines[0..$importIndex] + "import '../utils/app_logger.dart';" + $lines[($importIndex+1)..($lines.Length-1)]
            $lines | Set-Content $FilePath
        }
        
        # Replace print statements
        (Get-Content $FilePath) -replace "print\('([^']+)'\);", "AppLogger.debug('`$1');" | Set-Content $FilePath
    }
}

# Files to fix withOpacity issues
$WithOpacityFiles = @(
    "lib\screens\home\modern_home_screen.dart",
    "lib\screens\profile\profile_screen.dart", 
    "lib\screens\settings\settings_screen.dart",
    "lib\screens\camera\camera_screen.dart",
    "lib\screens\camera\enhanced_camera_screen.dart",
    "lib\utils\visual_effects.dart",
    "lib\widgets\modern_widgets.dart",
    "lib\widgets\photo_grid.dart"
)

# Fix withOpacity issues
Write-Host "🎨 Fixing deprecated withOpacity calls..." -ForegroundColor Cyan
foreach ($file in $WithOpacityFiles) {
    Fix-WithOpacity $file
}

Write-Host "✅ Code quality fixes completed!" -ForegroundColor Green
Write-Host "📊 Running analysis to check improvements..." -ForegroundColor Blue

# Run analysis
flutter analyze --no-fatal-infos

Write-Host "🎯 Code quality improvement complete! Check the analysis results above." -ForegroundColor Green