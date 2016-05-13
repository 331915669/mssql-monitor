select ''+ CHAR(13)+CHAR(10)+'����������Ƭ�ı�:';
-- Ensure a USE  statement has been executed first.
SELECT [DatabaseName]
    ,[ObjectId]
    ,[ObjectName]
    ,p.TableRows
    ,[IndexId]
    ,[IndexDescription]
    ,CONVERT(DECIMAL(16, 1), (SUM([avg_record_size_in_bytes] * [record_count]) / (1024.0 * 1024))) AS [IndexSize(MB)]
    ,[lastupdated] AS [StatisticLastUpdated]
    ,[AvgFragmentationInPercent]
FROM (
    SELECT DISTINCT DB_Name(Database_id) AS 'DatabaseName'
        ,OBJECT_ID AS ObjectId
        ,Object_Name(Object_id) AS ObjectName
        ,Index_ID AS IndexId
        ,Index_Type_Desc AS IndexDescription
        ,avg_record_size_in_bytes
        ,record_count
       -- p.rows
        ,STATS_DATE(object_id, index_id) AS 'lastupdated'
        ,CONVERT([varchar](512), round(Avg_Fragmentation_In_Percent, 3)) AS 'AvgFragmentationInPercent'
    FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, 'detailed')
    WHERE OBJECT_ID IS NOT NULL
        AND Avg_Fragmentation_In_Percent <> 0
    ) T
    inner join
    (SELECT SUM(p.rows) TableRows, p.OBJECT_ID
FROM sys.partitions p GROUP BY  p.OBJECT_ID) p
on T.ObjectId=p.object_id
GROUP BY DatabaseName
    ,ObjectId
    ,ObjectName
    ,IndexId
    ,IndexDescription
    ,lastupdated
    ,AvgFragmentationInPercent
    ,p.TableRows
    having(p.TableRows>10000)
    and ( cast(AvgFragmentationInPercent as float)>30)
    order by cast(AvgFragmentationInPercent as float)desc
    --,[IndexSize(MB)] desc;