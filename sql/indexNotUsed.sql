select ''+ CHAR(13)+CHAR(10)+'长时间没有使用的索引';
SELECT OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       USER_SEEKS, 
       USER_SCANS, 
       USER_LOOKUPS, 
       USER_UPDATES,
       --,
       --MAX(last_user_seek,last_user_sacn,_last_user_scan)
       --isnull(last_user_scan,cast(2000-01-01 as datetime))
       CASE WHEN isnull(last_user_seek,convert(datetime,2000,121))>isnull(last_user_scan,convert(datetime,2000,121)) and isnull(last_user_seek,convert(datetime,2000,121))>isnull(last_user_lookup,convert(datetime,2000,121)) then  isnull(last_user_seek,convert(datetime,2000,121))
       when isnull(last_user_scan,convert(datetime,2000,121))>isnull(last_user_seek,convert(datetime,2000,121)) and isnull(last_user_scan,convert(datetime,2000,121))>isnull(last_user_lookup,convert(datetime,2000,121)) then isnull(last_user_scan,convert(datetime,2000,121))
       when isnull(last_user_lookup,convert(datetime,2000,121)) >isnull(last_user_scan,convert(datetime,2000,121)) and isnull(last_user_lookup,convert(datetime,2000,121))>isnull(last_user_seek,convert(datetime,2000,121)) then isnull(last_user_lookup,convert(datetime,2000,121))
       end
       as last_used_time

FROM   SYS.DM_DB_INDEX_USAGE_STATS AS S 
       INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID 
WHERE  OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
       AND S.database_id = DB_ID()
       order by last_used_time;
