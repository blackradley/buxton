// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
// 

$(document).ready(function(){
  
  $('input.ui-datepicker').datepicker();
  
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
    $.get($(this).data("path"));
  })
  
  $('#submit_answers a').click(function(){
    if($('.checkStrand :checkbox:checked').size() == 0){
      return confirm('The assessment you are submitting has not identified any relevant equality strands.  Is this correct?');
    }
  });
  
  // Toggles the question depending on what is contained in the dependency hashes
  $('.question select, .question_compact select').change(function(obj){
    toggleDependencies(obj.srcElement);
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


function toggleDependencies(element){
  var select = $(element);
  var dependencies = $(element).parents('.question, .question_compact').data("dependencies");
  $.each(dependencies, function(question, required_value){
    if(required_value == $(select).val()){
      $("#"+question).show();
    }
    else{
      $("#"+question).hide();
    }
    toggleDependencies($("#"+question + " select"));
  }); 
}
