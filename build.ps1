$sln = '.\HelloForms.sln'
$verbosity = 'quiet'
$sleep = 10

$nuget = '.\nuget.exe'
if (!(Test-Path $nuget)) {
    Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $nuget
    & git add $nuget
}

function Touch {
    param ([string] $path)
    $date = (Get-Date)
    $date = $date.ToUniversalTime()
    $file = Get-Item $path
    $file.LastAccessTimeUtc = $date
    $file.LastWriteTimeUtc = $date
}

function MSBuild {
    param ([string] $msbuild, [string] $binlog)

    & $msbuild $sln /t:Compile /v:$verbosity /bl:$binlog /p:DesignTimeBuild=True /p:BuildingInsideVisualStudio=True /p:SkipCompilerExecution=True /p:ProvideCommandLineArgs=True
    if (!$?) {
        exit
    }

    # So git clean call doesn't delete
    & git add -f $binlog
}

function Profile {
    param ([string] $msbuild, [string] $version)
    
    & git clean -dxf
    & $nuget restore $sln
    Start-Sleep -Seconds $sleep

    MSBuild -msbuild $msbuild -binlog ".\dtb-$version.binlog"
}

# 15.7
$msbuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe'
Profile -msbuild $msbuild -version '15.7'

# 15.9
$msbuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe'
Profile -msbuild $msbuild -version '15.9'

# 16.0
$msbuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\MSBuild\Current\Bin\MSBuild.exe'
Profile -msbuild $msbuild -version '16.0'

# Print summary of results
$logs = Get-ChildItem .\*.binlog
foreach ($log in $logs) {
    $time = & $msbuild $log | Select-Object -Last 1
    Write-Host "$log $time"
}