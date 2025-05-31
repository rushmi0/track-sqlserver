#!/bin/bash


SERVER="localhost"
USERNAME="sa"
PASSWORD="Sql@Min123"
DATABASE="master"
OUTPUT_FILE="report_$(date +%F).csv"

SQL_QUERY="
SET NOCOUNT ON;
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
    ON mdf.database_id = ldf.database_id;
"

/opt/mssql-tools18/bin/sqlcmd \
  -S "${SERVER},1433" \
  -U "$USERNAME" \
  -P "$PASSWORD" \
  -d "$DATABASE" \
  -C \
  -W -s "," \
  -Q "$SQL_QUERY" > "$OUTPUT_FILE"


echo "Output saved to: $OUTPUT_FILE"