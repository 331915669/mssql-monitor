select ''+ CHAR(13)+CHAR(10)+'MSSQL实例信息';
SELECT physical_memory_kb / 1024 / 1024 AS SrvMemInGB, cpu_count, scheduler_count, affinity_type_desc, sqlserver_start_time, virtual_machine_type_desc  FROM sys.dm_os_sys_info;

select ''+ CHAR(13)+CHAR(10)+'获得实例的属性';  

EXEC sp_configure 'max server memory (MB)';
EXEC sp_configure 'min server memory (MB)';
EXEC sp_configure 'max degree of parallelism';

select ''+ CHAR(13)+CHAR(10)+'查看是否已经开启跟踪';
select id,
case status 
when 1 then 'running'
when 0 then 'stop'
end as status
,start_time,path from sys.traces where id<>1;


select ''+ CHAR(13)+CHAR(10)+'是否有游标没有关闭';
select session_id,cursor_id,name,creation_time from sys.dm_exec_cursors(0) where is_open=1;