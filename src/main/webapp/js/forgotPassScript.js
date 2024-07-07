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

let u=getCookie("email");
if(u==0)
{
	document.getElementById("message").innerHTML="We couldn't find an account associated with given info. Please try with an alternate email or date of birth";
	document.getElementById("email").style.outline="red solid 1px";
   	document.getElementById("email").style.border="1px solid red";
   	document.getElementById("dob").style.outline="red solid 1px";
   	document.getElementById("dob").style.border="1px solid red";
   	document.getElementById("body").style.background="linear-gradient(to top, rgb(255 0 0), rgb(255 255 255))";
}