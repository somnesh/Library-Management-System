function change()
{
    let v=document.getElementById("pass");
    v.setAttribute("type", "text");
    document.getElementById("eyes").innerHTML='<img class="fa-solid fa-eye" src="icons/eye-solid.svg" onclick="changeAgain()"></img>';
}
function changeAgain()
{
    let v=document.getElementById("pass");
    v.setAttribute("type", "password");
    document.getElementById("eyes").innerHTML='<img class="fa-solid fa-eye-slash" src="icons/eye-slash-solid.svg" onclick="change()"></img>';
}

//cookie

function getCookie(cName) 
{
	console.log("jeje");
	  const name = cName + "=";
	  const cDecoded = decodeURIComponent(document.cookie);
	  const cArr = cDecoded.split('; ');
	  let res;
	  cArr.forEach(val => {
	    if (val.indexOf(name) === 0) res = val.substring(name.length);
	  })
	  return res;
}
	
let email=getCookie("userEmail");

if(email!=null)
{
	document.getElementById("email").setAttribute("value",email);
	document.getElementById("pass").style.borderBottom="2px solid red";
	document.getElementById("email").style.borderBottom="2px solid red";
	document.getElementById("message2").innerHTML="Incorrect email or password. Please try again.";
}


