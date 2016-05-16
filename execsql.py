import sqlcon
import csv
import sys
from os import listdir, getcwd, chdir
from os.path import isfile, join, split, realpath


# 将sqldir目录下的所有文件格式化成sql语句，放到list中
def fn_getsqlcommand(sqldir):

    # 获取目录下所有的sql文件名
    sqlfilename = [f for f in listdir(sqldir) if isfile(join(sqldir, f))]
    sqlcommands = []
    for file in sqlfilename:

    # definite a function to execute sql
    # def fn_execsqlfile(filepath, filename):
        # Open and read the file as a single buffer
        """
        :param filename:
        """
        # 以只读方式打开sql文件

        fd = open(file, 'r')
        sqlfile = fd.read()
        fd.close()
        # 用分号（;）分割，获取获取sql语句

        sqlcommands = sqlcommands + sqlfile.split(';')
    return sqlcommands


# 定义sql文件存放的目录
mypath = join(split(realpath(sys.argv[0]))[0]+"\\", "sql")
# 切换到sql目录中
chdir(mypath)

# 定义存储查询结果的文件
rspath = join(split(realpath(sys.argv[0]))[0] + "\\", "result")

# 开启sql server连接
cursor = sqlcon.conn.cursor()

# 获取sql语句
sqlstatements = fn_getsqlcommand(mypath)

# 定义保存体检结果的文件
with open(rspath + "\\" + 'result.csv', 'a') as f:
    # 如果wr = csv.writer(f, dialect='excel')，则每个实际数据行后面还有一个空行
    wr = csv.writer(f, dialect='excel', lineterminator='\n')
    # wr = csv.writer(f, dialect='excel')

    # Execute every command
    for command in sqlstatements:
        if command.strip():
            cursor.execute(command)
            row = cursor.fetchone()

            # 获取列名，并且写入到excel中
            num_fields = len(cursor.description)
            field_names = [i[0] for i in cursor.description]
            if field_names:
                wr.writerow(field_names)

            # 遍历SQL查询的结果，写到excel中
            try:
                while row:  # row的格式为元组
                    wr.writerow(row)
                    row = cursor.fetchone()
            except:  # catch *all* exceptions
                e = sys.exc_info()[0]
                print(e)


# 结束SQL Server连接
cursor.close()
# 关闭文件句柄
f.close()

