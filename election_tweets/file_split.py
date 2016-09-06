with open('trump_tweets.json') as f:
	_max = 38031 / 3
	x = 0
	for line in f:
		x+=1
		if x >= _max:
			break
		with open('small_trump.json','a+') as f2:
			f2.write(line)