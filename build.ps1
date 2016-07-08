﻿

if($PSVersionTable.PSVersion.Major -eq 5){
    # Grab nuget bits, install modules, set build variables, start build.
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

    Install-Module Psake, PSDeploy, Pester, BuildHelpers -force
}
else {
    $modulePath = Join-Path "$env:temp" "Pester-master\Pester.psm1"
    if (-not(Test-Path $modulePath)) {
        $tempFile = Join-Path $env:TEMP pester.zip;Invoke-WebRequest 'https://github.com/pester/Pester/archive/master.zip' -OutFile $tempFile -usebasicparsing
        [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $env:temp)
    }
    $modulePath = Join-Path "$env:temp" "PSake-master\Psake.psm1"
    if (-not(Test-Path $modulePath)) {
        $tempFile = Join-Path $env:TEMP pester.zip;Invoke-WebRequest 'https://github.com/psake/psake/archive/master.zip' -OutFile $tempFile -usebasicparsing
        [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $env:temp)
    }
}
Import-Module Psake, Pester, BuildHelpers

Set-BuildEnvironment

Invoke-psake .\psake.ps1
exit ( [int]( -not $psake.build_success ) )