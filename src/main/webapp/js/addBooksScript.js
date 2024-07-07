function getCookie(cName) {
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
	
	
let statusCheck = getCookie("status");

if(statusCheck==2)
{
	console.log("status 2");
	document.getElementById("status").innerHTML="Duplicate book info ditected";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status-div").style.contentVisibility="visible";
	document.getElementById("status-div").style.paddingBottom = "3rem";
}

if(statusCheck==1)
{
	console.log("status 1");
	document.getElementById("status").innerHTML="Book added sucessfully";
	document.getElementById("status-div").style.contentVisibility="visible";
	document.getElementById("status-div").style.paddingBottom = "3rem";
}

if(statusCheck==0)
{
	console.log("status 0");
	document.getElementById("status").innerHTML="Something went wrong";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status-div").style.contentVisibility="visible";
	document.getElementById("status-div").style.paddingBottom = "3rem";  	
}