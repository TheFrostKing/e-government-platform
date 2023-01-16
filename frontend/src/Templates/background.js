
import image from "../images/wallpaper.jpg"; 

function Wallpaper() {
    return (
    
      <div style={{ backgroundImage:`url(${image})`,backgroundRepeat:"no-repeat",backgroundSize:"cover", 
      WebkitBackgroundSize:'cover', height:'94.3vh'}}>
    </div>
    
    );
  }
  
export default Wallpaper;