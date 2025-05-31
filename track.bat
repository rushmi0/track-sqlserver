@echo off


set SERVER=localhost
set USERNAME=sa
set PASSWORD=Sql@Min123
set DATABASE=master


for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set OUTPUT=report_%%i.csv


sqlcmd -S %SERVER%,1433 -U %USERNAME% -P %PASSWORD% -d %DATABASE% --encrypt trustservercertificate -W -s "," -Q "SET NOCOUNT ON;
SELECT
    mdf.database_id,
    mdf.name,
    mdf.physical_name AS data_file,
    ldf.physical_name AS log_file,
    CAST((mdf.size * 8.0) / 1024 AS DECIMAL(8, 2)) AS db_size,
    CAST((ldf.size * 8.0) / 1024 AS DECIMAL(8, 2)) AS log_size
FROM
    (SELECT * FROM sys.master_files WHERE type_desc = 'ROWS') mdf
JOIN
    (SELECT * FROM sys.master_files WHERE type_desc = 'LOG') ldf
    ON mdf.database_id = ldf.database_id;" > %OUTPUT%


echo Output saved to: %OUTPUT%