import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import { Link } from "react-router-dom";


function NavbarLoggedIn() {
  
  return (
   
    <Navbar bg="dark" variant="dark">
    
        <Nav>
          <Nav.Item>
            <Nav.Link as={Link} to="/" >Home</Nav.Link>
          </Nav.Item>
          
          <Nav.Item>
            <Nav.Link as={Link} to="/logout">Logout</Nav.Link>
          </Nav.Item>    

        </Nav>


    </Navbar>
  );
}

export default NavbarLoggedIn;