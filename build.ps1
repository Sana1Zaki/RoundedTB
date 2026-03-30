param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64",
    [switch]$Package
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildRoot = Join-Path $repoRoot "build"
$appOutput = Join-Path $buildRoot "app"
$packageOutput = Join-Path $buildRoot "package"

New-Item -ItemType Directory -Force -Path $appOutput | Out-Null
if ($Package) {
    New-Item -ItemType Directory -Force -Path $packageOutput | Out-Null
}

Write-Host "Building RoundedTB ($Configuration|$Platform)..." -ForegroundColor Cyan
msbuild "$repoRoot/RoundedTB.sln" /restore /p:Configuration=$Configuration /p:Platform=$Platform /p:OutputPath="$appOutput\" /verbosity:minimal

if ($Package) {
    Write-Host "Building MSIX package..." -ForegroundColor Cyan
    msbuild "$repoRoot/PackagingProject/RoundedTB.Package.wapproj" /restore /p:Configuration=$Configuration /p:Platform=$Platform /p:AppxPackageDir="$packageOutput\\" /p:GenerateAppxPackageOnBuild=true /verbosity:minimal
}
