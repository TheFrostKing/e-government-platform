import httpClient from '../httpClients.ts';
import Cookies from 'js-cookie';

const Logout=()=> {

  const logoutUser = async () => {

   httpClient.post('https://g4gov.com:444/logout')
   
   .then(function(response)  {
      console.log(response)
      Cookies.remove('session')
      window.location.href = "/login";
   })

   .catch(function (error) {
    console.log(error)
    Cookies.remove('session')
    window.location.href = "/login";
   })
  };

  logoutUser()

};
export default Logout;