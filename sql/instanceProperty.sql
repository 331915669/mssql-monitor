select ''+ CHAR(13)+CHAR(10)+'MSSQLʵ����Ϣ';
SELECT physical_memory_kb / 1024 / 1024 AS SrvMemInGB, cpu_count, scheduler_count, affinity_type_desc, sqlserver_start_time, virtual_machine_type_desc  FROM sys.dm_os_sys_info;

select ''+ CHAR(13)+CHAR(10)+'���ʵ��������';  

EXEC sp_configure 'max server memory (MB)';
EXEC sp_configure 'min server memory (MB)';
EXEC sp_configure 'max degree of parallelism';

select ''+ CHAR(13)+CHAR(10)+'�鿴�Ƿ��Ѿ���������';
select id,
case status 
when 1 then 'running'
when 0 then 'stop'
end as status
,start_time,path from sys.traces where id<>1;


select ''+ CHAR(13)+CHAR(10)+'�Ƿ����α�û�йر�';
select session_id,cursor_id,name,creation_time from sys.dm_exec_cursors(0) where is_open=1;