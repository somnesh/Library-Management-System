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
if(statusCheck==330)
{
	console.log("status 330");
	document.getElementById("status").innerHTML='Request Submitted Successfully';
	document.getElementById("status-div").style.contentVisibility="visible";
	document.getElementById("status").style.background="#009300";
}

if(statusCheck==331)
{
	console.log("status 331");
	document.getElementById("status").innerHTML='Request Submission failed';
	document.getElementById("status-div").style.contentVisibility="visible";
}

if(statusCheck==332)
{
	console.log("status 332");
	document.getElementById("status").innerHTML='The book already exists in the library';
	document.getElementById("status-div").style.contentVisibility="visible";
}

if(statusCheck==333)
{
	console.log("status 332");
	document.getElementById("status").innerHTML='The book request already made';
	document.getElementById("status-div").style.contentVisibility="visible";
}