// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
// 

jQuery.expr[':'].Contains = function(a,i,m){
    return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
};

var sorter;

$(document).ready(function(){
  
  $('.formtastic.activity #standardInputs input').change(function(){
    if($("#standardInputs").find(":text[value=]").length == 0){
      $("#readyInput").show();
    }
    else{
      $("#readyInput").hide();
    }
  });
  
  $('.schedule').click(function(){
    var visible_activities = $('tr.light:visible, tr.dark:visible').map(function(){return "activities[]=" + $(this).data("activity-id")});
    $(this).attr("href", $(this).data("root-path") + "?" + $.makeArray(visible_activities).join("&"));
  });
  
  $("td:empty").html("&nbsp;");
    
  $('input.ui-datepicker').datepicker();
  
  $(".saveLink").click(function(){
    $(this).parent().submit();
    return false;
  });
  
  $('#searchForm').submit(function(){
    var term = $('#search_term').val();
    $("table.searchable tbody tr td:not(.last):not(:Contains('"+term+"'))").parents("tr").hide();
    $("table.searchable tbody tr td:not(.last):Contains('"+term+"')").parents("tr").show();
    return false;
  });

  
  $('.sortControls a').click(function() {
    sorter.wk(this.parentNode.cellIndex, this.className == 'down');
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
    var footer_visible = $('.completionRequired.complete:visible').length == $('.completionRequired:visible').length;
    if(footer_visible){
      $(".approvalStep").show();
      $(".mockApprovalStep").hide();
    }
    else{
      $(".approvalStep").hide();
      $(".mockApprovalStep").show();
    }
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
    $.get($(this).data("path"), function(data){
      $(issue_link).parents(".question").children("span#issues_list").append(data);
      $('.deleteNewIssue').click(function(){
        $(this).parent('.issue').remove();
        return false;
      });
    })
    return false;
  });
  
  if ($('#sortable').length) {
    sorter = new TINY.table.sorter('sorter');
    sorter.head = 'sortControls'; //header class name
    sorter.asc = 'sortControls asc'; //ascending header class name
    sorter.desc = 'sortControls desc'; //descending header class name
    sorter.even = 'dark'; //even row class name
    sorter.odd = 'light'; //odd row class name
    // sorter.evensel = 'evenselected'; //selected column even class
    // sorter.oddsel = 'oddselected'; //selected column odd class
    // sorter.paginate = false; //toggle for pagination logic
    // sorter.pagesize = 20; //toggle for pagination logic
    // sorter.currentid = 'currentpage'; //current page id
    // sorter.limitid = 'pagelimit'; //page limit id
    sorter.init('sortable',0,true);
  }
  
  $('.retiredCheckbox :checkbox').click(function(){
    $.post($(this).data("path"));
    if($(this).is(":checked")){
      $(this).parents("tr").children("td:first").append("<span class='retired'>(Retired)</span>");
    }
    else{
      $(this).parents("tr").find(".retired").remove();
    }
  });
  
  
  $('.activitySummary').colorbox();
  
  
  $('.issueEdit').click(function(){
    var issue = $(this).parents(".issue");
    issue.find(".issueEdit, .issueDetails").toggle();
    if(issue.find(".issueAction").is(":visible")){
      issue.find(".issueAction").focus();
    }
    return false;
  })

  $('.deleteIssue').click(function(){
    $(this).siblings('.issue_destroy').val('1');
    $(this).closest('.issue').hide();
    return false;
  });
  
  
  $(".colorbox").click(function(){
    $(this).colorbox({'href': $(this).data("path")});
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
