// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Show or hide
function toggleHelp(node){
  if (node.tagName && node.tagName.toLowerCase() == 'div')
    node.style.display = (node.style.display == 'block') ? 'none' : 'block';
}

function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.directorate').hide();
}

function mark_for_issue_destroy(element) {
	$(element).next('.issue_destroy').value = 1;
	$(element).up('.issue').hide();
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


