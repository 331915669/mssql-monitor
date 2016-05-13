select ''+ CHAR(13)+CHAR(10)+'数据库属性信息';
SELECT 
name, collation_name, is_auto_close_on, is_auto_shrink_on, recovery_model_desc, 
page_verify_option_desc, is_auto_create_stats_on, is_auto_update_stats_on, is_published, log_reuse_wait_desc
  from sys.databases where database_id=db_id();

select ''+ CHAR(13)+CHAR(10)+'获取数据库的备份信息';
select b1.database_name,b1.name,b1.backup_start_date,b2.physical_device_name
 from msdb.dbo.backupset b1 
   join msdb.dbo.backupmediafamily b2 on b1.media_set_id=b2.media_set_id
   where database_name=db_name() order by backup_start_date desc;