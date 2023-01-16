import httpClient from '../httpClients.ts';
import Navbar from './nav_loggedin';
import Cookies from 'js-cookie';
import { useMemo, useEffect, useState } from 'react';
import { Button } from 'react-bootstrap';
import { ListGroup } from 'react-bootstrap';
import { Card } from 'react-bootstrap';
import EasyEdit, {Types} from 'react-easy-edit';

function SetAddress() {
    const saveCountry = (value) => {myData.country=value}
    const saveCity = (value) => {myData.city=value}
    const saveStreet = (value) => {myData.street=value}
  
    const myData = useMemo(() => ({
      country: "",
      city: "",
      street: ""
    }), []);
    
    
    const cancel = () => {console.log("Cancelled")}
    const [message, setMessage] = useState([{}]);
    

    useEffect(()  => {
        httpClient.get("https://g4gov.com:444/user").then(response => {
        setMessage(response.data)
        myData.country = response.data.country
        myData.city = response.data.city
        myData.street = response.data.street
        console.log(response.data)
    })
    .catch(error => {
        if (error.response.status === 401){
             window.location.href = "/login"
             Cookies.remove('session')
        }
    })

    }, [myData]);

    const UpdateAddress = () => {

        try {
          httpClient.post("https://g4gov.com:444/change/address", myData);
          
        } catch (error) {
          error.log(error)
          if (error.response.status === 401) {
            alert("Invalid credentials");
    
          }
        }
    
      };
    
    return (
        <div className=""> <Navbar></Navbar>
        <div className="top-0 start-0">
    
            <Card style={{ width: '18rem'}}>
                    
                    <ListGroup>
                    <ListGroup.Item>BSN: {message.bsn}</ListGroup.Item>

<ListGroup.Item><EasyEdit
      type={Types.TEXT}
      placeholder={message.city}
      onSave={saveCity}
      onCancel={cancel}
      attributes={{ name: "awesome-input", id: 1}}/></ListGroup.Item>

<ListGroup.Item><EasyEdit
      type={Types.TEXT}
      placeholder={message.country}
      onSave={saveCountry}
      onCancel={cancel}
      attributes={{ name: "awesome-input", id: 1}}/></ListGroup.Item>

<ListGroup.Item><EasyEdit
      type={Types.TEXT}
      placeholder={message.street}
      onSave={saveStreet}
      onCancel={cancel}
      attributes={{ name: "awesome-input", id: 1}}/></ListGroup.Item>

                    </ListGroup>
            </Card>

             <Button variant="primary" type="button" onClick={() => UpdateAddress()}>Submit</Button>

        </div>
    </div>

        
    )
}
    
export default SetAddress

