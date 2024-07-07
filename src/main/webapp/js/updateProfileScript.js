//cookie

console.log("jeje");
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

	//storing cookie values into variables
	
	let emailCheck=getCookie("emailCheck");
	let phoneCheck=getCookie("phoneCheck");
	let regCheck = getCookie("regCheck");
	let rollCheck = getCookie("rollCheck");
	
	//form values
	let firstName=getCookie("firstName");
	let lastName=getCookie("lastName");
	let email=getCookie("email");
	let phone=getCookie("phone");
	let reg = getCookie("reg");
	let roll = getCookie("roll");
	let department=getCookie("department");
	let dob=getCookie("dob");
	let village=getCookie("village");
	let district=getCookie("district");
	let post=getCookie("post");
	let pin=getCookie("pin");

	if(emailCheck!=undefined || phoneCheck!=undefined || regCheck!=undefined || rollCheck!=undefined)
	{
		console.log(emailCheck);
		console.log(phoneCheck);
		console.log(regCheck);
		console.log(rollCheck);
		
		document.getElementById("firstName").setAttribute("value",firstName);
       	document.getElementById("lastName").setAttribute("value",lastName);

       	document.getElementById("phone").setAttribute("value",phone);

       	
       	document.getElementById("dob").setAttribute("value",dob);
       	document.getElementById("village").setAttribute("value",village);
       	document.getElementById("district").setAttribute("value",district);
       	document.getElementById("post").setAttribute("value",post);
       	document.getElementById("pin").setAttribute("value",pin);
	}
	
	
	if(phoneCheck==1)
	{
		console.log("phone");
		//document.getElementById("message2").innerHTML="This phone number already exists. Try another.";
       	document.getElementById("phone").style.outline="red solid 1px";
       	document.getElementById("phone").style.border="1px solid red";
	}
	
	let statusCheck = getCookie("status");

if(statusCheck==2)
{
	console.log("status 2");
	document.getElementById("status").innerHTML="Duplicate info ditected";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status-div").style.contentVisibility="visible";
	document.getElementById("status-div").style.paddingBottom = "3rem";
}

if(statusCheck==1)
{
	console.log("status 1");
	document.getElementById("status").innerHTML="Details updated sucessfully";
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