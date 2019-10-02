import shodan
import sys

api = shodan.Shodan('1N3sJ8CZE6q2ZUXVfixXP1wZvacwVXCH')

if len(sys.argv) == 1:
	print('Usage:%s <search query>' % sys.argv[0])
	sys.exit(1)
try:
	query = ' '.join(sys.argv[1:])
	result = api.search(query)

	for service in result['matches']:
		print(service['ip_str']+":"+str(service['port']))
except Exception as e:
	print ('Error: %s' % e)
	sys.exit(1)
