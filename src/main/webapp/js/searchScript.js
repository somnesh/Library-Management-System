function validate(){
        let input = document.getElementById("srh");
        if(/^\s/.test(input.value))
        input.value = '';
        console.log(input.value);
    }
    
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
if(statusCheck==20)
{
	console.log("status 20");
	document.getElementById("status").innerHTML='Your borrow limit has been reached. Return some books or <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">contact Admin/Librarian</a> to increase borrow limit';
	document.getElementById("status-div").style.contentVisibility="visible";
}