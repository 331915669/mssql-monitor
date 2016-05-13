import sqlcon
import csv
import sys
from os import listdir, getcwd, chdir
from os.path import isfile, join, split, realpath

# definite a function to execute sql
def fn_execsqlfile(filepath, filename):
    # Open and read the file as a single buffer
    """
    :param filename:
    """
    # 以只读方式打开sql文件

    fd = open(filename, 'r')
    sqlfile = fd.read()
    fd.close()
    # 用分号（;）分割，获取获取sql语句
    sqlcommands = sqlfile.split(';')

    # 开启sql server连接
    cursor = sqlcon.conn.cursor()

    with open(filepath + "\\" + 'result.csv', 'a') as f:
        # 如果wr = csv.writer(f, dialect='excel')，则每个实际数据行后面还有一个空行
        wr = csv.writer(f, dialect='excel', lineterminator='\n')
        # wr = csv.writer(f, dialect='excel')

    # Execute every command from the input file
        for command in sqlcommands:
            if command.strip():
                cursor.execute(command)
                row = cursor.fetchone()

                # 获取列名，并且写入到excel中
                colNameList= []

                num_fields = len(cursor.description)
                field_names = [i[0] for i in cursor.description]

                # for i in range(len(cursor.description)):
                #     desc = cursor.description[i]
                #     colNameList.append(desc[0])

                wr.writerow(field_names)

                # 遍历SQL查询的结果，写到excel中
                try:
                    while row:  # row的格式为元组
                        wr.writerow(row)
                        row = cursor.fetchone()
                except:  # catch *all* exceptions
                    e = sys.exc_info()[0]
                    return e
                    # 关闭文件句柄

            # 结束SQL Server连接
    cursor.close()
    # sqlcon.conn.close()
    f.close()


# 遍历目录中的所有SQL文件

# 定义sql文件存放的目录
mypath = join(split(realpath(sys.argv[0]))[0]+"\\", "sql")
# 切换到sql目录中
chdir(mypath)
# 获取目录下所有的文件名
sqlfilename = [f for f in listdir(mypath) if isfile(join(mypath, f))]

# 定义存储查询结果的文件
resultpath = join(split(realpath(sys.argv[0]))[0] + "\\", "result")


# 遍历文件，将文件名传递到函数中
for file in sqlfilename:
    # fn_execsqlfile的作用：执行传入的sql文件，然后将结果以csv的格式保存
    fn_execsqlfile(resultpath, file)




