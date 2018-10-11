# $sln = '.\HelloWorld.sln'
# $csproj = '.\HelloWorld\HelloWorld.csproj'
$sln = '.\HelloForms.sln'
$csproj = '.\HelloForms\HelloForms.Android\HelloForms.Android.csproj'
$msbuild = '..\xamarin-android\bin\Debug\bin\xabuild.exe'
$verbosity = 'quiet'
$sleep = 30

$nuget = '.\nuget.exe'
if (!(Test-Path $nuget)) {
    Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $nuget
    & git add $nuget
}

function XABuild {
    param ([string] $target, [string] $binlog, [string] $extra = '')

    & $msbuild $csproj /t:$target /v:$verbosity /bl:$binlog $extra
    if (!$?) {
        exit
    }

    # So git clean call doesn't delete
    & git add -f $binlog
}

function Profile {
    param ([string] $binlog, [string] $extra = '')
    
    # Reset working copy
    & git clean -dxf
    & $nuget restore $sln
    Start-Sleep -Seconds $sleep

    XABuild -target 'SignAndroidPackage' -binlog $binlog -extra $extra
}

Remove-Item .\*.binlog*
Profile -binlog 'dx.binlog'
Profile -binlog 'd8.binlog' -extra '/p:AndroidDexGenerator=d8'
Profile -binlog 'd8-no-desugar.binlog' -extra '/p:AndroidDexGenerator=d8;AndroidEnableDesugar=False'
Profile -binlog 'dx-proguard.binlog' -extra '/p:AndroidLinkTool=proguard'
Profile -binlog 'd8-r8.binlog' -extra '/p:AndroidDexGenerator=d8;AndroidLinkTool=r8'

# Print summary of results
$logs = Get-ChildItem ".\*.binlog"
foreach ($log in $logs) {
    $time = & msbuild $log | Select-Object -Last 1
    Write-Host "$log $time"
    & msbuild /clp:performancesummary $log > "$log.summary.txt"
}
