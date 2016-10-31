// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function (__global) {
    if (!__global.console || (__global.console && !__global.console.log)) {
        __global.console = {
            log: (__global.opera && __global.opera.postError)
                ? __global.opera.postError
                : function() {
                }
        };
    }
})(this);

/* javascript logger */
var inspector = {};

Inspector = {
    inspect: function(val) {
        if (val.innerHTML) {
            Logger.log(val.innerHTML);
        } else {
            Logger.log(val);
        }
    },

    inspectArray: function(array) {
        array.each(this.inspect);
    }
};

function get_journal_entry_id() {
  if(Cookies.get('journal_entry') == "true"){
    $('login_box').show();
  }
}

function scrollToBottom(elem) {
   elem.scrollTop = elem.scrollHeight;
}

// call a method that updates the dynamic parts of a survey 
function get_dynamic_fragments(url, opt) {
 // alert ("Loading: " + url + "  args: " + opt );
	new Ajax.Request( url, {
	// method: 'post', // default is post
		parameters: opt,
		onSuccess: function(transport) { /* alert( transport.responseText ); */ },
		onFailure: function() { /* alert( "Unable to raise request" ); */ }
	});
};

function get_js_fragments(url, onsuccessfn) {
 // alert ("Loading: " + url + "  args: " + opt );
	new Ajax.Request( url, {
	    method: 'get', // default is post
		parameters: {},
		onSuccess: function(transport) { if(typeof onsuccessfn !== 'undefined') onsuccessfn(); /* alert( transport.responseText ); */ },
		onFailure: function() { /* alert( "Unable to raise request" ); */ }
	});
};

function get_draft(url, opt) {
  new Ajax.Request(url, {
		parameters: opt,
    // contentType: "text/javascript",
    // evalJS: true,
	  onSuccess: function(transport) { eval(transport.responseText); }
	});
}

function changeAction(formid, actionvalue) {
 	document.getElementById(formid).action = actionvalue;
}

function setFormStatusInWindow(result, form) {
	if(!result) {
		window.status = "Der er manglende eller forkerte værdier i besvarelsen";
		return false;
	}
	if(result) { 
		window.status = "Sender besvarelsen...";
	}
	return true;
}

function getElementValue(formElement)
{
	if(formElement.length != null) var type = formElement[0].type;
	if((typeof(type) == 'undefined') || (type == 0)) var type = formElement.type;

	switch(type)
	{
		case 'undefined': return;

		case 'radio':
			for(var x=0; x < formElement.length; x++) 
				if(formElement[x].checked == true)
			return formElement[x].value;

		case 'select-multiple':
			var myArray = new Array();
			for(var x=0; x < formElement.length; x++) 
				if(formElement[x].selected == true)
					myArray[myArray.length] = formElement[x].value;
			return myArray;

		case 'checkbox': return formElement.checked;
	
		default: return formElement.value;
	}
}

function setElementValue(formElement, value)
{
	switch(formElement.type)
	{
		case 'undefined': return;
		case 'radio': formElement.checked = value; break;
		case 'checkbox': formElement.checked = value; break;
		case 'select-one': formElement.selectedIndex = value; break;

		case 'select-multiple':
			for(var x=0; x < formElement.length; x++) 
				formElement[x].selected = value[x];
			break;

		default: formElement.value = value; break;
	}
}

function toggleRadio(rObj) {
	if (!rObj) return false;
	
	rObj.__chk = rObj.__chk ? rObj.checked = !rObj.__chk : rObj.checked;
	// console.log(rObj);
	
	// when a button is unchecked, the default button is checked
	if(!rObj.checked) {
		var def_radio = new String(rObj.id.match(/q[0-9]+_[0-9]+_[0-9]+_/));
		def_radio = def_radio + "9";
		$(def_radio).checked = true;
		// console.log('checking default button: ' + def_radio);
	}
	return true;
}

function toggleCheck(rObj) {
	// when clicking checkbox, set value in hidden input with same name
	if (!rObj) return false;
	var inputName = rObj.name;
	var selectHidden = "input[name='" + inputName + "']";
	var hiddenElem = $("input[name='" + inputName + "']");
	hiddenElem.val(rObj.checked ? 1 : 0);
	return true;
}

function toggleComments(form) {
    var comments = $$('.comment');
    if(comments.length == 0)
    	return;
    var visible = comments[0].visible();
    comments.each(function(v) {
    	if(visible)
    		v.hide();
    	else
    		v.show();
    });
}

// turns on/off comment boxes
function toggleComment(input) {
    var elm = $(input);
		if(elm.disabled) {
      elm.enable();
			elm.show();
     }
    else {
      elm.disable();
			elm.hide();
    }
		return false;
}

function toggleElem(input) {
	var elm = $(input);
	elm.toggle();
}

function toggleElems(input) {
  try { 

		var elms = $A(document.getElementsByClassName(input)).reverse();
		elms.each(function(elm) {
			// Effect.toggle(elm,'blind',{});;
			(elm.toggle());
		});
  } catch (e) {}
}


function search_help() {
	$("#search_help").toggle(!$("#search_help").is(':visible'));
}


function hide_search_help() {
	$("#search_help").fadeOut();
}

