import httpClient from '../httpClients.js';
import Navbar from './nav_loggedin';
// import Cookies from 'js-cookie';
import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Button } from 'react-bootstrap';

function App() {
  const [isLoading, setLoading] = useState(true);
  const [message, setMessage] = useState();

  useEffect(()  => {
    httpClient.get("https://g4gov.com:444/user").then(response => {
      setMessage(response.data);
      setLoading(false)})
      .catch((error) => {
        if (error.response.status === 401) {
          // Cookies.remove('session')
          window.location.href = "/login";
        }
      });
      
  }, []);

  if (isLoading) {
    return <div className="App">Loading...</div>;
  }
  

  return (
    <div>
    { <Navbar/>}
    <h1>Hi, {message.first_name}</h1>
    <Link to="/address"><Button variant="dark">set/change address</Button></Link>
    <br/>
    <Link to="/address"><Button variant="dark">set/change address</Button></Link>
    </div>
    
  
  );
  
}


export default App;