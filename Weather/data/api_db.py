import os
import requests
import pandas as pd
from datetime import datetime, timedelta, timezone
import time
import json
import logging
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, MetaData, Table
from sqlalchemy.orm import sessionmaker

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Prompt user for database credentials
db_username = input("Enter your database username: ")
db_password = input("Enter your database password: ")

# Set the API key 
api_key = os.getenv('OPENAQ_API_KEY')

# Define the parameters
config = {
    "country": 'AU',
    "parameters": ['co', 'o3', 'ch4', 'pm25', 'pm4', 'pm10', 'so2', 'no', 'no2'],
    "interval_days": 30,
    "database_url": f'postgresql+psycopg2://{db_username}:{db_password}@localhost:5432/postgres'
    
}

end_date = datetime.now(timezone.utc)
start_date = end_date - timedelta(days=365 * 10)  # Last decade

# Setup database
engine = create_engine(config['database_url'])
metadata = MetaData()

air_quality_table = Table(
    'air_quality', metadata,
    Column('id', Integer, primary_key=True),
    Column('location', String),
    Column('city', String),
    Column('country', String),
    Column('parameter', String),
    Column('value', Float),
    Column('unit', String),
    Column('date_utc', DateTime),
    Column('latitude', Float),
    Column('longitude', Float)
)

metadata.create_all(engine)
Session = sessionmaker(bind=engine)
session = Session()

def fetch_data(start_date, end_date, parameter):
    url = "https://api.openaq.org/v2/measurements"
    headers = {
        "X-API-Key": api_key,
        "accept": "application/json",
    }
    params = {
        "country": config['country'],
        "parameter": parameter,
        "date_from": start_date.strftime('%Y-%m-%dT%H:%M:%SZ'),
        "date_to": end_date.strftime('%Y-%m-%dT%H:%M:%SZ'),
        "page": 1,
    }
    all_data = []
    while True:
        response = requests.get(url, headers=headers, params=params)
        if response.status_code == 408:  # Retry on timeout
            time.sleep(1)  # Wait for a second before retrying
            continue
        elif response.status_code != 200:
            logging.error(f"Failed to fetch data: {response.status_code}")
            break

        data = response.json()
        all_data.extend(data['results'])

        if 'meta' in data and 'found' in data['meta']:
            total_results_str = str(data['meta']['found'])
            if total_results_str.startswith('>'):
                total_results = int(total_results_str[1:]) + 1  # Handle '>' character
            else:
                total_results = int(total_results_str)
        else:
            total_results = len(data['results'])

        if len(all_data) >= total_results:
            break

        params["page"] += 1

    return all_data

def save_data_to_db(data, session):
    records = []
    for record in data:
        date_utc = datetime.strptime(record['date']['utc'], '%Y-%m-%dT%H:%M:%S%z')
        records.append({
            'location': record['location'],
            'city': record['city'],
            'country': record['country'],
            'parameter': record['parameter'],
            'value': record['value'],
            'unit': record['unit'],
            'date_utc': date_utc,
            'latitude': record['coordinates']['latitude'],
            'longitude': record['coordinates']['longitude']
        })
    
    session.execute(air_quality_table.insert(), records)
    session.commit()

def main():
    for parameter in config['parameters']:
        logging.info(f"Fetching data for parameter: {parameter}")
        current_start_date = start_date
        while current_start_date < end_date:
            current_end_date = min(current_start_date + timedelta(days=config['interval_days']), end_date)
            logging.info(f"Fetching data from {current_start_date} to {current_end_date}")
            data = fetch_data(current_start_date, current_end_date, parameter)
            if data:
                save_data_to_db(data, session)
                logging.info(f"Batch for {parameter} from {current_start_date} to {current_end_date} completed and saved.")
            current_start_date = current_end_date

    logging.info("Data fetching completed.")

    # Querying data for demonstration
    df = pd.read_sql_table('air_quality', engine)
    logging.info(df.info())
    logging.info(df.head())

    # Checking for duplicates and null values
    logging.info(f"Number of duplicates: {df.duplicated().sum()}")
    logging.info(f"Number of null values:\n{df.isnull().sum()}")
    logging.info(f"Unique locations:\n{df['location'].unique()}")

if __name__ == "__main__":
    main()