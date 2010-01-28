// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function mark_for_destroy(element) {
  $(element).next('.should_destroy').value = 1;
  $(element).up('.directorate').hide();
}

function mark_for_organisation_manager_destroy(element) {
  $(element).next('.should_destroy').value = 1;
  $(element).up('.organisation_manager').hide();
}

function mark_for_strategy_destroy(element) {
  $(element).next('.should_destroy').value = 1;
  $(element).up('.strategy').hide();
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
  var ungrey = document.getElementsByClassName('question_compact');
  for (var i = 0; i < ungrey.length; i++){
     //Do Work on doc[i], this sets the border of the Div black
     ungrey[i].style.background = "#fff";
  }
  var help = document.getElementById(element);
  help.style.display = "block";

  var grey = document.getElementById(element2);
  grey.style.background = "#eee";
}

function setDependencyTrue(sub_question){
   document.getElementById(sub_question).style.display = "block";
}
function checkDependancy(main_question, sub_question, value){
  var dependent = document.getElementById(sub_question);

  var question = document.getElementById('activity_' + main_question);
  if (question.value!=value){
    dependent.style.display = "none";
  }
}

function hideall(element){//we hide all of them
    var hide = document.getElementsByClassName(element);
	  for (var i = 0; i < hide.length; i++){
	     //Do Work on doc[i], this sets the border of the Div black
	     hide[i].style.display = "none";
	  }
}
function showall(element){//we hide all of them
    var show = document.getElementsByClassName(element);
	  for (var i = 0; i < show.length; i++){
	     //Do Work on doc[i], this sets the border of the Div black
	     show[i].style.display = "block";
	  }
}

function updatePreview (elem) {
  switch(elem.id){
    case 'email':
      $('act_man').innerHTML = elem.value;
      $('act_approv').innerHTML = elem.value;
      break;
    case 'activity':
      $('act_name').innerHTML = elem.value;
      break;
    case 'organisation':
      $('org_name').innerHTML = $('organisation').value;
      break;
  }
}