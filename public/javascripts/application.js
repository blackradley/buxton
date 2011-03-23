// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
// 

jQuery.expr[':'].Contains = function(a,i,m){
    return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
};


$(document).ready(function(){
  
  $('input.ui-datepicker').datepicker();
  
  $(".saveLink").click(function(){
    $(this).parent().submit();
    return false;
  });
  
  $('#searchForm').submit(function(){
    var term = $('#search_term').val();
    $("table.searchable tbody tr:not(:Contains('"+term+"'))").hide();
    $("table.searchable tbody tr:Contains('"+term+"')").show();
    return false;
  });
  
  $('.sortControls a').click(function() {
    var link = $(this)
    
    var col = link.parents('tr').children().index($(this).parents('th'))+1;
    var desc = link.hasClass('down');
    var childElem = null;
    $('.sortControls a').removeClass('selected');
    link.addClass('selected');
    
    if (link.parents('table').find('tbody tr td:nth-child('+col+') :checkbox').length > 0) {
      childElem = ':checkbox';
    }
    
    link.parents('table').sortTable({onCol : col, sortDesc : desc, keepRelationships : true, child : childElem});
    return false;
  });
  
  $('.question:not(.saveField), .question_compact').click(function(){
    $('.more').hide();
    $('.focused').removeClass("focused");
    $(this).addClass("focused");
    $("#more_" + $(this).attr("id")).show();
  });  
  
  $('.question:not(.saveField) select, .question_compact select').focus(function(){
    $('.more').hide();
    $('.focused').removeClass("focused");
    $(this).parents('.question:not(.saveField), .question_compact').addClass("focused");
    $("#more_" + $(this).parents('.question:not(.saveField), .question_compact').attr("id")).show();
  });  
  
  // Toggles strands on the activity depending on what value is checked.
  $('span.checkStrand input').click(function(){
    var strand = $(this).attr('id').replace("_checkbox", "");
    $('#row_'+ strand).toggle();
    $.post($(this).data("path"));
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
  if(dependencies){
    $.each(dependencies, function(question, required_value){
      if($(select).is(":visible") && required_value == $(select).val()){
        $("#"+question).show();
      }
      else{
        $("#"+question).hide();
      }
      toggleDependencies($("#"+question + " select"));
    }); 
  }
}
