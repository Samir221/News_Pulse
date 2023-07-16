import json
import os
import requests
from google.cloud import bigquery
from google.cloud import storage

def download_json(request):
    # Replace with your API endpoint
    API_ENDPOINT = 'https://financialmodelingprep.com/api/v3/available-traded/list?apikey=728883d73a69cfac83c4ba8b7d10f076'

    # Fetch data from API
    response = requests.get(API_ENDPOINT)
    data = response.json()

    # Initialize a Cloud Storage client and set the bucket and blob details
    storage_client = storage.Client()
    bucket_name = 'your-bucket-name'  # Replace with your Cloud Storage Bucket name
    blob = storage_client.get_bucket(bucket_name).blob('data.json')

    # Upload JSON data to Cloud Storage
    blob.upload_from_string(
        data=json.dumps(data),
        content_type='application/json'
    )

    # Initialize a BigQuery client
    bq_client = bigquery.Client()

    # Set table_id to the ID of the table to create.
    table_id = "your-project.your_dataset.your_table"  # Replace with your table id

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
        autodetect=True,
        write_disposition='WRITE_TRUNCATE' # This will overwrite the table
    )

    uri = f"gs://{bucket_name}/data.json"

    load_job = bq_client.load_table_from_uri(
        uri, table_id, job_config=job_config
    )  # Make an API request.

    load_job.result()  # Waits for the job to complete.

    return 'JSON data has been loaded into BigQuery', 200
