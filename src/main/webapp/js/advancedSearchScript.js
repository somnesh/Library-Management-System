function validate(){
        let input = document.getElementById("srh");
        if(/^\s/.test(input.value))
        input.value = '';
        console.log(input.value);
    }

function submitForm(id)
    {
    	var uncheck=document.getElementsByName('book');
        for(var i=0;i<uncheck.length;i++)
        {
            if(uncheck[i].type=='checkbox')
            {
                uncheck[i].checked=false;
            }
        }
    	
    	console.log(id);
    	document.getElementById(id).checked = true;
    	console.log("checked");
    	document.getElementById("form").submit();
    }
    
    
    function submitForm(id,e,d)
    {
    	var uncheck = document.getElementsByName('book');
    	var uncheckEdit = document.getElementsByName('edit');
    	var uncheckDelete = document.getElementsByName('delete');
    	
        for(var i=0;i<uncheck.length;i++)
        {
            if(uncheck[i].type=='checkbox')
            {
                uncheck[i].checked=false;
            }
        }
        
        for(var i=0;i<uncheckEdit.length;i++)
        {
            if(uncheckEdit[i].type=='checkbox')
            {
            	uncheckEdit[i].checked=false;
            }
        }
        
        for(var i=0;i<uncheckDelete.length;i++)
        {
            if(uncheckDelete[i].type=='checkbox')
            {
            	uncheckDelete[i].checked=false;
            }
        }
    	
    	console.log(id);
    	console.log(e);
    	console.log(d);
    	document.getElementById(id).checked = true;
    	if(e!=null)
    		e.checked = true;
    	if(d!=null){
    		if(confirm("Are you want to delete this book ?"))
    			d.checked = true;
    		else
    			exit(0);
    	}
    	console.log("checked");
    	document.getElementById("form").submit();
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