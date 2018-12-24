import shodan
import sys
api = shodan.Shodan('1N3sJ8CZE6q2ZUXVfixXP1wZvacwVXCH')

#result = api.search('tomcat')
#print(result['total'])
#for result in result['matches']:
#	print ('IP:%s' % result['ip_str'])
#	print ('Ports:%s' % result['port']) 
#	print ('')

FACETS = [
	'org',
	'domain',
	'port',
	'asn',
]

FACET_TITLES = {
	'org': 'Top 5 Organizations',
	'domain': 'Top 5 Doamins',
	'port': 'Top 5 Ports',
	'asn': 'Top 5 Automomous Systems',
	'country': 'Top 3 Countries',
}

if len(sys.argv) == 1:
	print('Usage:%s <search query>' % sys.argv[0])
	sys.exit(1)

try:
	query = ' '.join(sys.argv[1:])
	result = api.count(query, facets=FACETS)

	print ('Shodan Summary Information')
	print ('Query: %s' % query)
	print ('total result: %s\n' % result['total'])

	for facet in result['facets']:
		print(FACET_TITLES[facet])

		for term in result['facets'][facet]:
			print('%s: %s' % (term['value'],term['count']))

		print ('')
except Exception as e:
	print('Error: %s' % e)
	sys.exit(1)