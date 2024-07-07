//--------------------------------- #status -------------------------------

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

console.log(statusCheck);

if(statusCheck==1)
{
	console.log("status 1");
	document.getElementById("status").innerHTML="User Banned";
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==2)
{
	console.log("status 2");
	document.getElementById("status").innerHTML="Borrow limit updated";
	
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==3)
{
	console.log("status 3");
	document.getElementById("status").innerHTML="User Activated";
	
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==4)
{
	console.log("status 4");
	document.getElementById("status").innerHTML="User Deleted";
	
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==5)
{
	console.log("status 5");
	document.getElementById("status").innerHTML="Department Deleted";
	
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==6)
{
	console.log("status 5");
	document.getElementById("status").innerHTML="Publisher Deleted";
	
	document.getElementById("status").removeAttribute("hidden");
}

if(statusCheck==0)
{
	console.log("status 0");
	document.getElementById("status").innerHTML="Something went wrong";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status").removeAttribute("hidden"); 	
}

if(statusCheck==7)
{
	console.log("status 0");
	document.getElementById("status").innerHTML="Cannot delete Department because it is in use";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status").removeAttribute("hidden"); 	
}

if(statusCheck==8)
{
	console.log("status 0");
	document.getElementById("status").innerHTML="Cannot delete Publisher because it is in use";
	document.getElementById("status").style.border="2px solid red";
	document.getElementById("status").style.color="red";
	document.getElementById("status").removeAttribute("hidden"); 	
}

let timeout=false;

/*while(statusCheck!=undefined)
{
	console.log("oh shit")
	timeout=true;
}

if(timeout)
{
	document.getElementById("status").setAttribute("hidden","hidden");
	console.log("yeet");
}*/

function submitForm(id,ban,activate,limit,del)
{	
	
	let scroll = document.body.scrollTop;
	sessionStorage.setItem("scroll", scroll);

	console.log("scroll = "+scroll);
	
	var uncheck = document.getElementsByName('sid');
	var uncheckBan = document.getElementsByName('ban');
	var uncheckActivate = document.getElementsByName('Activate');
	var uncheckDelete = document.getElementsByName('delete');
	var uncheckLimit = document.getElementsByName('limit');
	
    for(var i=0;i<uncheck.length;i++)
    {
        if(uncheck[i].type=='checkbox')
        {
            uncheck[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckBan.length;i++)
    {
        if(uncheckBan[i].type=='checkbox')
        {
        	uncheckBan[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckActivate.length;i++)
    {
        if(uncheckActivate[i].type=='checkbox')
        {
        	uncheckActivate[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckDelete.length;i++)
    {
        if(uncheckDelete[i].type=='checkbox')
        {
        	uncheckDelete[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckLimit.length;i++)
    {
        if(uncheckLimit[i].type=='checkbox')
        {
        	uncheckLimit[i].checked=false;
        }
    }
	
	console.log(id);
	console.log(del);
	console.log(ban);
	console.log(activate);
	console.log(limit);
	
	document.getElementById(id).checked = true;
	if(ban!=null)
		ban.checked = true;
	
	if(del!=null){
		if(confirm("Are you want to delete this user ?"))
			del.checked = true;
		else
			exit(0);
	}
	
	if(activate!=null)
		activate.checked = true;
	
	if(limit!=null)
		limit.checked = true;
	
	console.log("checked");
	document.getElementById("form").submit();
}