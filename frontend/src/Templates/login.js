import React, {useState} from 'react';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import Card from 'react-bootstrap/Card';
import Navbar from './nav.js';
import Cookies from 'js-cookie';
import httpClient from '../httpClients.js';
import Wallpaper  from './background.js';
import { Link } from "react-router-dom"

const LoginPage=()=> {
const [bsn, setBSN] = useState("");
const [password, setPassword] = useState("");


  const logInUser = async () => {
    // console.log(bsn, password);

    try {
      await httpClient.post("https://g4gov.com:444/login", {
        bsn,
        password,
      });

      window.location.href = "/";
      
    } catch (error) {
      if (error.response.status === 401) {
        alert("Invalid credentials");
        Cookies.remove('session')

      }
    }

  };
    

  
  return (
    
    <div>
      <Navbar/>
      <Wallpaper></Wallpaper>
        <Card style={{ width: '18rem', margin: '0 auto',float:'none', position:'absolute', top:'25%',right:'25%', left:'25%'}}>
          <Card.Body>
            <Form>
            <Form.Group className="mb-3" controlId="formBasicbsn">
                <Form.Label>BSN</Form.Label>
                <Form.Control type="bsn" placeholder="Enter bsn" value={bsn}
                onChange={(e) => setBSN(e.target.value)}/>
              
            </Form.Group>

            <Form.Group className="mb-3" controlId="formBasicPassword">
                <Form.Label>Password</Form.Label>
                <Form.Control type="password" placeholder="Password" 
                onChange={(e) => setPassword(e.target.value)} />
                <Form.Text className="text-muted">
              <Link to="/register">Register</Link>
              </Form.Text>
            </Form.Group>
            <Form.Group className="mb-3" controlId="formBasicCheckbox">
                {/* <Form.Check type="checkbox" label="Check me out" /> */}
            </Form.Group>
            <Button variant="primary" type="button" onClick={() => logInUser()}>
                Submit
            </Button>
            </Form>

          </Card.Body>
        </Card>
      </div>
    );
  };


export default LoginPage;