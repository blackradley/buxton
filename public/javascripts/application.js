// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Show or hide
function mytoggle(node){
  thisElement = document.getElementById(node);
  thisElement.style.display = (thisElement.style.display == 'block') ? 'none' : 'block';
}

function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.directorate').hide();
}

function mark_for_issue_destroy(element) {
	$(element).next('.issue_destroy').value = 1;
	$(element).up('.issue').hide();
}

document.getElementsByClassName = function(className, parentElement) {
  if (typeof parentElement == 'string'){
    parentElement = document.getElementById(parentElement);
  } else if (typeof parentElement != 'object' ||
             typeof parentElement.tagName != 'string'){
    parentElement = document.body;
  }
  var children = parentElement.getElementsByTagName('*');
  var re = new RegExp('\\b' + className + '\\b');
  var el, elements = [];
  var i = 0;
  while ( (el = children[i++]) ){
    if ( el.className && re.test(el.className)){
      elements.push(el);
    }
  }
  return elements;

}


function setFocus(element, element2){
	var doc = document.getElementsByClassName('more');
	for (var i = 0; i < doc.length; i++){
	   //Do Work on doc[i], this sets the border of the Div black
	   doc[i].style.display = "none";
	}
	var ungrey = document.getElementsByClassName('question');
	for (var i = 0; i < ungrey.length; i++){
	   //Do Work on doc[i], this sets the border of the Div black
	   ungrey[i].style.background = "#fff";
	}
	var help = document.getElementById(element);
	help.style.display = "block";
	
	var grey = document.getElementById(element2);
	grey.style.background = "#eee";
}

function checkDependancy(main_question, sub_question, value){
	var dependent = document.getElementById(sub_question);
	dependent.style.display = "none";
	
	var question = document.getElementById('activity_' + main_question);
	
	if (question.value==value){
		dependent.style.display = "block";
	}
	
	

	
}


