import EasyEdit, {Types} from 'react-easy-edit';
import httpClient from '../httpClients.ts';
import Button from 'react-bootstrap/Button';


function Edit() {
  
  const save = (value) => {console.log(value)}
  const cancel = () => {console.log("Cancelled")}

  const UpdateAddress = () => {

    try {
       httpClient.post("https://g4gov.com:444/change/address", {
        save
      });
      
    } catch (error) {
      if (error.response.status === 401) {
        alert("Invalid credentials");

      }
    }

  };

  return (
    <div>
    <EasyEdit
      type={Types.TEXT}
      onSave={save}
      onCancel={cancel}
      saveButtonLabel="Save Me"
      cancelButtonLabel="Cancel Me"
      attributes={{ name: "awesome-input", id: 1}}
    />
    <Button variant="primary" type="button" onClick={() => UpdateAddress()}>
                Submit
    </Button>
    </div>  
  );
  
}

export default Edit