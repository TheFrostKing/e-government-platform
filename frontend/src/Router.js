import { Routes, Route } from "react-router-dom"
import Login from './Templates/login.js'
// import NavScrollExample from './Templates/nav.js';
import LandingPage from "./Templates/landingpage.js";
import Logout from "./Templates/logout.js";

import SetAddress from "./Templates/address.js";
import Edit from "./Templates/test_edit.js";
import RegisterPage from "./Templates/register.js";

function App() {
  return (
    <div>
    <Routes>
      <Route path="/login" element={<Login/>} />
      <Route path="/logout" element={<Logout/>} />
      <Route path="/" element = { <LandingPage/> }/>
      <Route path="/address" element = { <SetAddress/>}/>
      <Route path="/edit" element = { <Edit/>}/>
      <Route path="/register" element = { <RegisterPage/>}/>
    </Routes>
    </div>
    )
  }


export default App;
