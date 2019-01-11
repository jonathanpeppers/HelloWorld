$sln = '.\HelloForms.sln'
$csproj = '.\HelloForms\HelloForms.Android\HelloForms.Android.csproj'
$packageName = 'HelloForms.HelloForms'
$adb = 'C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe'
$verbosity = 'quiet'
$suffix = ''

$nuget = '.\nuget.exe'
if (!(Test-Path $nuget)) {
    Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $nuget
    & git add $nuget
}

function MSBuild {
    param ([string] $msbuild, [string] $target, [string] $binlog)

    & $msbuild $csproj /t:$target /v:$verbosity /bl:$binlog
    if (!$?) {
        exit
    }

    # So git clean call doesn't delete
    & git add -f $binlog
}

function Profile {
    param ([string] $msbuild, [string] $version)
    
    # Reset working copy & device
    & $adb uninstall $packageName
    & git clean -dxf
    & $nuget restore $sln

    # First
    MSBuild -msbuild $msbuild -target 'Install' -binlog "./first-$version$suffix.binlog"

    # Second
    MSBuild -msbuild $msbuild -target 'Install' -binlog "./second-$version$suffix.binlog"
}

# 15.9.5
$msbuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe'
Profile -msbuild $msbuild -version '15.9'

# 16.0 P2
$msbuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\MSBuild\Current\Bin\MSBuild.exe'
Profile -msbuild $msbuild -version '16.0'

# Print summary of results
$logs = Get-ChildItem .\*.binlog
foreach ($log in $logs) {
    $time = & $msbuild $log | Select-Object -Last 1
    Write-Host "$log $time"
}