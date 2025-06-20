SET NOCOUNT ON;
SELECT
    mdf.database_id,
    mdf.name,
    mdf.physical_name AS data_file,
    ldf.physical_name AS log_file,
    CAST((mdf.size * 8.0) / 1024 / 1.024 AS DECIMAL(8, 2)) AS db_size,
    CAST((ldf.size * 8.0) / 1024 / 1.024 AS DECIMAL(8, 2)) AS log_size
FROM
    (SELECT * FROM sys.master_files WHERE type_desc = 'ROWS') mdf
JOIN
    (SELECT * FROM sys.master_files WHERE type_desc = 'LOG') ldf
    ON mdf.database_id = ldf.database_id;
