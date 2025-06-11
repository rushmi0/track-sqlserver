@echo off

set SERVER=localhost
set USERNAME=sa
set PASSWORD=sql@min123
set DATABASE=master

if not exist records (
    mkdir records
)


for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HH-mm-ss"') do set DATETIME=%%i

set OUTPUT=records\report_%DATETIME%.csv
set TEMPFILE=records\temp_%DATETIME%.csv

echo database_id,name,data_file,log_file,db_size_mb,log_size_mb > %OUTPUT%


sqlcmd -S %SERVER%,1433 -E -d %DATABASE% -C -W -s "," -h -1 -i query.sql -o %TEMPFILE%
rem sqlcmd -S %SERVER%,1433 -U %USERNAME% -P %PASSWORD% -d %DATABASE% -C -W -s "," -i query.sql -o %OUTPUT%

type %TEMPFILE% >> %OUTPUT%

del %TEMPFILE%

echo Output saved to: %OUTPUT%
