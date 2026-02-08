import jwt
import time
import requests
import json

key = '696d7554b68e3f0001f097f2:68c18287c22f301200742d64b24676f9fd0313c31fe80bf464eedf8697160f0a'
key_id, key_secret = key.split(':')

iat = int(time.time())
header = {'alg': 'HS256', 'typ': 'JWT', 'kid': key_id}
payload = {'iat': iat, 'exp': iat + 300, 'aud': '/admin/'}

token = jwt.encode(payload, bytes.fromhex(key_secret), algorithm='HS256', headers=header)

# Try creating a simple test post using v5 API
post_data = {
    'posts': [{
        'title': 'Test Post',
        'mobiledoc': json.dumps({'version': '0.3.1', 'atoms': [], 'cards': [['markdown', {'markdown': 'Hello World'}]], 'markups': [], 'sections': [[10, 0]]}),
        'status': 'draft'
    }]
}

# Try different API versions
urls = [
    'https://guyanadailybrief.com/ghost/api/v5/admin/posts/',
    'https://guyanadailybrief.com/ghost/api/v4/admin/posts/',
    'https://guyanadailybrief.com/ghost/api/v3/admin/posts/',
    'https://guyanadailybrief.com/ghost/api/admin/posts/',
]

for url in urls:
    response = requests.post(
        url,
        headers={'Authorization': f'Ghost {token}', 'Content-Type': 'application/json'},
        json=post_data
    )
    print(f'{url}')
    print(f'Status: {response.status_code}')
    if response.status_code == 201:
        print('SUCCESS!')
        break
    print('')
