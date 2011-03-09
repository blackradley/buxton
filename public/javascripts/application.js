// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
// 

$(document).ready(function(){
  
  $(".saveLink").click(function(){
    $(this).parent().submit();
    return false;
  });
  
  $('.question:not(.saveField), .question_compact').click(function(){
    $('.more').hide();
    $('.focused').removeClass("focused");
    $(this).addClass("focused");
    $("#more_" + $(this).attr("id")).show();
  });  
  
  // Toggles strands on the activity depending on what value is checked.
  $('span.checkStrand input').click(function(){
    var strand = $(this).attr('id').replace("_checkbox", "");
    $('#row_'+ strand+ '_on').toggle();
    $('#row_'+ strand+ '_off').toggle();
    $.get("/activities/toggle_strand?strand=" + strand);
  })
  
  // Toggles the question depending on what is contained in the dependency hashes
  $('.question select, .question_compact select').change(function(){
    var select = $(this);
    var dependencies = $(this).parents('.question, .question_compact').data("dependencies");
    $.each(dependencies, function(question, required_value){
      if(required_value == $(select).val()){
        $("#"+question).show();
      }
      else{
        $("#"+question).hide()
      }
    });
  });
  
  $('.addIssue').click(function(){
    var issue_link = this
    $.get("/issues/new?section=" + $(issue_link).data("section") + "&strand=" + $(issue_link).data("strand"), function(data){
      $(issue_link).parents(".question").children("span#issues_list").append(data);
      $('.issueDeleteLink').click(function(){
        $(this).up(".issue").remove()
        return false;
      });
    })
    return false;
  });
  
  $('.issueDeleteLink').click(function(){
    $(this).up(".issue").remove()
    return false;
  });
});

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

function setDependencyTrue(sub_question){
  if($(sub_question)){
   $(sub_question).style.display = "block";
  }
  else{
    return true;
  }
}

function checkDependancy(main_question, sub_question, value){
  var dependent = document.getElementById(sub_question);
  if(dependent){
    var question = document.getElementById('activity_' + main_question);
    if (question.value!=value){
      dependent.style.display = "none";
    }
  }
  else{
    return true;
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
      $('org_name').innerHTML = elem.value;
      break;
  }
}