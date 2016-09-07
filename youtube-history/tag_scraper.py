import csv
import numpy as np
from apiclient.discovery import build
import json

# Load Dataset
with open("./Youtube History Data.csv") as f:
    reader = csv.reader(f)
    raw_data = [list(x) for x in reader]
data = np.array(raw_data[1:])

# Youtube Data Collection
with open('youtube_config.json') as f:
    DEVELOPER_KEY = json.loads(f.read())['api_key']
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
                developerKey=DEVELOPER_KEY)


def get_video_tags(id_):
    search_response = youtube.videos().list(
        id=id_,
        part="snippet",
      ).execute()
    try:
        if 'tags' in search_response['items'][0]['snippet']:
            return search_response['items'][0]['snippet']['tags']
    except IndexError:
        print search_response

video_tags = ({'id': x[2], 'date': x[1], 'tags': get_video_tags(x[2])}
              for x in data)

with open('video_data.json', 'w+') as f:
    for tag_dict in video_tags:
        f.write(json.dumps(tag_dict))
        f.write('\n')
