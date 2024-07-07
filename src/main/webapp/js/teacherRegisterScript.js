let q="'",qo=",";
function change(p,d)
{
    let v=document.getElementById(p);
    v.setAttribute("type", "text");
    document.getElementById(d).innerHTML='<img class="fa-solid fa-eye" src="icons/eye-solid.svg" onclick="changeAgain('+q+p+q+qo+q+d+q+')"></img>';
}
function changeAgain(p,d)
{
    let v=document.getElementById(p);
    v.setAttribute("type", "password");
    document.getElementById(d).innerHTML='<img class="fa-solid fa-eye-slash" src="icons/eye-slash-solid.svg" onclick="change('+q+p+q+qo+q+d+q+')"></img>';
}

function check()
{
	console.log("in check");
    let pass1=document.getElementById("pass").value;
    let pass2=document.getElementById("conPass").value;
    let sub=document.getElementById('submit');
    if (pass1!=pass2) 
    {
        document.getElementById("message").innerHTML="Those passwords didn't match. Try again.";
        sub.setAttribute("disabled","disabled");
        document.getElementById("conPass").style.outline="red solid 1px";
        document.getElementById("conPass").style.border="1px solid red";
        document.getElementById("pass").style.outline="red solid 1px";
        document.getElementById("pass").style.border="1px solid red";
    }
    else{
        document.getElementById("message").innerHTML="";
        sub.removeAttribute("disabled","disabled");
        document.getElementById("conPass").style.removeProperty("outline");
        document.getElementById("conPass").style.removeProperty("border");
        document.getElementById("pass").style.removeProperty("outline");
        document.getElementById("pass").style.removeProperty("border");
    }
}

 let input = document.getElementById("conPass");
	    input.addEventListener("keypress", function(event) {
	        if (event.key === "Enter") {
	            check();
	        }
	    });

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
	
	let statusCheck = getCookie("status");
	let emailCheck=getCookie("emailCheck");
	let phoneCheck=getCookie("phoneCheck");
	
	//form values
	let firstName=getCookie("firstName");
	let lastName=getCookie("lastName");
	let email=getCookie("email");
	let phone=getCookie("phone");
	let department=getCookie("department");
	let dob=getCookie("dob");
	let village=getCookie("village");
	let district=getCookie("district");
	let post=getCookie("post");
	let pin=getCookie("pin");

	if(emailCheck!=undefined || phoneCheck!=undefined)
	{
		console.log(emailCheck);
		console.log(phoneCheck);
		
		document.getElementById("firstName").setAttribute("value",firstName);
       	document.getElementById("lastName").setAttribute("value",lastName);
       	document.getElementById("email").setAttribute("value",email);
       	document.getElementById("phone").setAttribute("value",phone);
       	
       	let deptArr = department.split("+");
       	if(deptArr>1)
		{
			department = deptArr[0]+" "+deptArr[1];
		}
       	document.getElementById("department").value = department;
       	document.getElementById("dob").setAttribute("value",dob);
       	document.getElementById("village").setAttribute("value",village);
       	document.getElementById("district").setAttribute("value",district);
       	document.getElementById("post").setAttribute("value",post);
       	document.getElementById("pin").setAttribute("value",pin);
	}
	
	if(emailCheck==1)
	{
		console.log("email");
		//document.getElementById("message3").innerHTML="That email is taken. Try another.";
		document.getElementById("email").style.outline="red solid 1px";
       	document.getElementById("email").style.border="1px solid red";
	}
	
	if(phoneCheck==1)
	{
		console.log("phone");
		//document.getElementById("message2").innerHTML="This phone number already exists. Try another.";
       	document.getElementById("phone").style.outline="red solid 1px";
       	document.getElementById("phone").style.border="1px solid red";
	}
	
	if(statusCheck==1)
	{
		console.log("status");
		document.getElementById("status").innerHTML="Account Created sucessfully";
		document.getElementById("status-div").style.contentVisibility="visible";
		document.getElementById("status-div").style.paddingBottom = "3rem";
       	
	}
	
	if(statusCheck==0)
	{
		console.log("status");
		document.getElementById("status").innerHTML="Something went wrong";
		document.getElementById("status").style.border="2px solid red";
		document.getElementById("status").style.color="red";
		document.getElementById("status-div").style.contentVisibility="visible";
		document.getElementById("status-div").style.paddingBottom = "3rem";
       	
	}