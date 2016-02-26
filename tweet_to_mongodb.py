from pymongo import MongoClient
import json

FILE_NAME = "gop_debate.json"

if __name__ == "__main__":
	client = MongoClient('localhost',27017)
	db = client['twitter_db']
	collection = db['twitter_collection']
	num_lines = sum(1 for line in open(FILE_NAME))
	with open(FILE_NAME,'r') as f:
		x = 0
		for line in f:
			tweet = json.loads(line)
			collection.insert(tweet)
			x+=1
			if x % 1000 == 0:
				print str(x) + " out of " + str(num_lines)