import pytest
import json

from app import app as application

def test_home():
    response = application.test_client().get('/home')

    assert response.status_code == 401

def test_health():
    response = application.test_client().get('/health')

    assert response.status_code == 200
    assert response.json == {"test":"healthy"}
    
def test_register_user_existing_bsn():
    # Set up the request data
    data = {
        "bsn": 12345678,
        "password": "mypassword",
        "firstName": "John",
        "lastName": "Doe",
        "city": "New York",
        "street": "Main Street",
        "country": "USA"
    }

    # Send a POST request to the /register endpoint
    response = application.test_client().post("/register", data=json.dumps(data), content_type="application/json")

    # Assert that the response has the correct status code and error message
    assert response.status_code == 409
    assert response.json == {"error": "User already exists"}

def test_login_user():
     # Set up the request data
    data = {
        "bsn": 12345678,
        "password": "mypassword"
    }

    # Send a POST request to the /register endpoint
    response = application.test_client().post("/login", data=json.dumps(data), content_type="application/json")

    # Assert that the response has the correct status code and error message
    assert response.status_code == 200
    assert response.json == {"bsn": 12345678}



