import Nav from 'react-bootstrap/Nav';
import { Link } from "react-router-dom";
import Cookies from 'js-cookie'
import Navbar from 'react-bootstrap/Navbar';


function Navbar2() {

  
  const isLoggedIn = () => {
    // console.log(Cookies.get('session'))
    const cookie_status = Boolean(Cookies.get('session'))
    // Cookies.set('session',{ path: '/',  expires:0} )
    console.log(cookie_status)
    return cookie_status
  }
  
  return (
   
    <Navbar bg="dark" variant="dark">

    
        <Nav>
          <Nav.Item>
            {isLoggedIn() ? <Nav.Link as={Link} to="/" >Home</Nav.Link>:''}
          </Nav.Item>


          <Nav.Item>
            {isLoggedIn() ? <Nav.Link as={Link} to="/logout" >Logout</Nav.Link>:<Nav.Link as={Link} to="/login" >Login</Nav.Link>}
          </Nav.Item>    
          <Nav.Item>
            {<Nav.Link as={Link} to="/register" >Register</Nav.Link>}
          </Nav.Item>

        </Nav>


    </Navbar>
  );
}

export default Navbar2;