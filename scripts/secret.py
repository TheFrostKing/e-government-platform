import boto3
import json

secret_name = "test/db/mysql"
region_name = "eu-central-1"

# Create a Secrets Manager client
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)

get_secret_value_response = client.get_secret_value(SecretId=secret_name)

# Decrypts secret using the associated KMS key.
secret = get_secret_value_response['SecretString']

password = json.loads(secret)['password']

with open("./backend/config.py","r") as file:
    file_data = file.read()
    new_data = file_data.replace('secret', password)
    print(new_data)
    
with open("./backend/config.py","w") as file:
    file.write(new_data)


