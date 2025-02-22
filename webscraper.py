from bs4 import BeautifulSoup
import requests
from datetime import datetime
from time import sleep

import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate('slugswole-firebase-adminsdk-fbsvc-fbb36e9143.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

def task():
        # Your task goes here
        # Functionised because we need to call it twice
        url = "https://campusrec.ucsc.edu/FacilityOccupancy"
        r = requests.get(url)
        r.raise_for_status()

        soup = BeautifulSoup(r.text, features="html.parser")

        fitness_center_section = soup.find('div', {'id': 'facility-1799266f-57d9-4cb2-9f43-f5fd88b241db'})
        occupancy_value = fitness_center_section.find(attrs={'data-occupancy': True})['data-occupancy']
        print("scraped occ value: " + occupancy_value)
        db.collection('weekly_capacity_data').add({"timestamp":firestore.SERVER_TIMESTAMP, 'capacity':occupancy_value})
        print(f"successfully pushed data {occupancy_value} at {firestore.SERVER_TIMESTAMP}")

def run(condition):
    while datetime.now().minute not in {0, 15, 30, 45}:  # Wait 1 second until we are synced up with the 'every 15 minutes' clock
        sleep(1)
    task()
    while condition == True:
        sleep(60*15)  # Wait for 15 minutes
        curr_hour = datetime.now().hour
        if curr_hour >= 8 and curr_hour < 22:
            task()  # 'Start' the task (i.e trigger the cron-job, but through the Python library instead

        
run(1)
