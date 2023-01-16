import React, {useState} from 'react';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import Card from 'react-bootstrap/Card';
import Navbar from './nav.js';
import httpClient from '../httpClients.js';
import image from "../images/wallpaper.jpg"; 


const RegisterPage =()=> {
const [bsn, setBSN] = useState("");
const [password, setPassword] = useState("");
const [confirmPassword, setConfirmPassword] = useState("");
const [country, setCountry] = useState("");
const [street, setStreet] = useState("");
const [city, setCity] = useState("");
const [firstName, setFirstName] = useState("");
const [lastName, setLastName] = useState("");


  const registerUser = async () => {
    if (password !== confirmPassword) {
        alert("Passwords don't match")
    }
    else{
        try {
        await httpClient.post("https://g4gov.com:444/register", {
            bsn,
            password,
            firstName,
            confirmPassword,
            lastName,
            country,
            street,
            city
        });

        window.location.href = "/login";
        
        } catch (error) {
        if (error.response.status === 409) {
            alert("existing bsn");
        }

        if (error.response.status === 401){
            console.log("some internal problem")
        }
        }

    }
  };
    
  
  return (
    
    <div>
      <Navbar/>
      <div style={{ backgroundImage:`url(${image})`,backgroundRepeat:"no-repeat",backgroundSize:"cover", 
      WebkitBackgroundSize:'cover', height:'94.3vh'}}>
      </div>
        <Card style={{ width: '25rem', margin: '0 auto',float:'none', position:'absolute', top:'10%', right:'2.5%', left:'2.5%'}}>
          <Card.Body>
            <Form color='grey'>

            <Form.Group className="mb-3" controlId="formBasicbsn">
                <Form.Label>BSN</Form.Label>
                <Form.Control type="bsn" placeholder="Enter bsn" value={bsn}
                onChange={(e) => setBSN(e.target.value)}/>
            </Form.Group>

            <Form.Group className="mb-3" controlId="formBasicPassword">
                <Form.Label>Password</Form.Label>
                <Form.Control type="password" placeholder="Password" 
                onChange={(e) => setPassword(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3" controlId="formBasicPassword">
                <Form.Label>Confirm Password</Form.Label>
                <Form.Control type="password" placeholder="Type password again" 
                onChange={(e) => setConfirmPassword(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3" controlId="name">
                <Form.Label>Name</Form.Label>
                <Form.Control type="name" placeholder="Name" value={firstName}
                onChange={(e) => setFirstName(e.target.value)}/>
            </Form.Group>

            <Form.Group className="mb-3" controlId="LastName">
                <Form.Label>Surname</Form.Label>
                <Form.Control type="name" placeholder="Surname" value={lastName}
                onChange={(e) => setLastName(e.target.value)}/>
            </Form.Group>

            <Form.Group className="mb-3" controlId="country">
                <Form.Label>Country</Form.Label>
                <Form.Control type="country" placeholder="Country of residence" value={country}
                onChange={(e) => setCountry(e.target.value)}/>
            </Form.Group>

            <Form.Group className="mb-3" controlId="City">
                <Form.Label>City</Form.Label>
                <Form.Control type="city" placeholder="City" value={city}
                onChange={(e) => setCity(e.target.value)}/>
            </Form.Group>

    

            <Form.Group className="mb-3" controlId="street">
                <Form.Label>Street</Form.Label>
                <Form.Control type="street" placeholder="Street" value={street}
                onChange={(e) => setStreet(e.target.value)}/>
            </Form.Group>
            
            <Button variant="primary" type="button" onClick={() => registerUser()}>
                Submit
            </Button>
            </Form>

          </Card.Body>
        </Card>
      </div>
    );
  };


export default RegisterPage;
