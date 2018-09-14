# "Hello World" and "Hello Forms"

A quick `File | New Project` for timing Xamarin.Android builds.

Just run (I might have harcoded paths in this script, sorry!):

    .\build.ps1

Used in Xamarin.Android's [wiki here](https://github.com/xamarin/xamarin-android/wiki/Build-Performance-Ideas).

Raw results for "Hello Forms":
```
first-build-15.8.binlog    Time Elapsed 00:00:35.93
first-build-15.9.binlog    Time Elapsed 00:00:37.33
first-install-15.8.binlog  Time Elapsed 00:00:15.22
first-install-15.9.binlog  Time Elapsed 00:00:12.90
first-package-15.8.binlog  Time Elapsed 00:00:07.74
first-package-15.9.binlog  Time Elapsed 00:00:07.33
second-build-15.8.binlog   Time Elapsed 00:00:02.99
second-build-15.9.binlog   Time Elapsed 00:00:02.75
second-install-15.8.binlog Time Elapsed 00:00:03.07
second-install-15.9.binlog Time Elapsed 00:00:02.83
second-package-15.8.binlog Time Elapsed 00:00:03.05
second-package-15.9.binlog Time Elapsed 00:00:02.72
third-build-15.8.binlog    Time Elapsed 00:00:08.03
third-build-15.9.binlog    Time Elapsed 00:00:06.63
third-install-15.8.binlog  Time Elapsed 00:00:07.06
third-install-15.9.binlog  Time Elapsed 00:00:05.20
third-package-15.8.binlog  Time Elapsed 00:00:06.03
third-package-15.9.binlog  Time Elapsed 00:00:04.51
```