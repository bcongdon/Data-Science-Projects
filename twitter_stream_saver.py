from TwitterAPI import TwitterAPI
from TwitterAPI import TwitterError
import random, time, json

import sys  

reload(sys)  
sys.setdefaultencoding('utf8')

with open('credentials.json','r') as f:
    creds = json.loads(f.read())
    consumer_key = creds['consumer_key']
    consumer_secret = creds['consumer_secret']
    access_token_key = creds['access_token_key']
    access_token_secret = creds['access_token_secret']
    
api = TwitterAPI(consumer_key,
                 consumer_secret,
                 access_token_key,
                 access_token_secret)


SEARCH_TERM = "Donald Trump"

def save_tweet(data):
    with open('output.json','a') as f:
        f.write(json.dumps(data) + '\n')

if __name__ == "__main__":
    while True:
        try:
            iterator = api.request('statuses/filter', {'track':SEARCH_TERM}).get_iterator()
            for item in iterator:
                print item['text']
                save_tweet(item)
        except TwitterError.TwitterRequestError as e:
            if e.status_code < 500:
                # something needs to be fixed before re-connecting
                raise
            else:
                # temporary interruption, re-try request
                pass
        except TwitterError.TwitterConnectionError:
            # temporary interruption, re-try request
            pass
