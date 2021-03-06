// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//
//= require jquery
//= require jquery_ujs
//= require jquery.colorbox
//= require_tree .

if ( ! window.console ) console = { log: function(){} };

jQuery.expr[':'].Contains = function(a,i,m){
    return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
};

var sorter;

$(document).ready(function(){

  $(document).on('change', '#accept_box', function(e){
    if ( $(this).is(':checked') ) {
      $('.enabled').show();
      $('.disabled').hide();
    } else {
      $('.enabled').hide();
      $('.disabled').show();
    }
  });

  $(document).on('change', '#activity_directorate', function(e){
    $.ajax({
      url: $('#service_areas_path_div').data( "path" ),
      type: 'POST',
      data: { directorate_id: parseInt( $(this).val() ) }
    });
  });

  $(document).on("click", '.add_officer_link', function(e){
    $('.multi').append('<div class="input_div"><label></label><input data-autocomplete="/directorates/autocomplete_user_email" name="directorate[cop_email][]" size="30" type="text" value="" class="ui-autocomplete-input" autocomplete="off" role="textbox" aria-autocomplete="list" aria-haspopup="true"><a href="#" class="delete_dgo">delete</a><br/></div>');
    $('.multi input[data-autocomplete]').railsAutocomplete();
    e.preventDefault();
  });

  $(document).on('click', '.delete_dgo', function(e){
    $(this).prev().prev().prev().remove();
    $(this).prev().prev().remove();
    $(this).prev().remove();
    $(this).next().remove();
    $(this).remove();
  });

  $('.mask').height($('.mask').parent().height());
  $('.formtastic.activity #standardInputs input').bind('keyup change', function(){
    if($("#standardInputs").find(":text[value='']").length == 0){
      $("#readyInput, #descriptiveReadyText").show();
    }
    else{
      $("#readyInput, #descriptiveReadyText").hide();
    }
  });

  $('.consultation_save').click(function(e){
    // if($('.consultation_checker').filter(function(x){return $(this).val()=='2'}).size() == 2){
    //   if(e.preventDefault) e.preventDefault();
    //   $.colorbox({html: $('.consultationColorbox').html()});
    // } else {
      $(this).val('Saving...');
      $(this).attr('disabled', 'disabled');
      $(this).parents('form').submit();
    // }
  });

  $(document).on('click', '.closeColorBox', function(e){
    e.preventDefault();
    $.colorbox.close()
  });

  $(".formSubmit").click(function(e){
    $(this).parents("form").submit();
    e.preventDefault();
  })

  $(document).on('click', 'a.activityFormSubmitLink', (function(e){
    $('form.edit_activity').submit();
    e.preventDefault();
  }));

  $('.schedule').click(function(e){
    var visible_activities = $('tr.light:visible, tr.dark:visible').map(function(){return $(this).data("activity-id")});
    $("#activities").val($.makeArray(visible_activities));
    e.preventDefault();
    $(this).closest("form").submit();
  });

  $("td:empty").html("&nbsp;");
  $('input.ui-datepicker').datepicker({ dateFormat: 'dd/mm/yy' });

  $(".saveLink").click(function(){
    $(this).parent().submit();
    return false;
  });

  $('#searchForm').submit(function(){
    if(!$(this).hasClass("directorateSearch")){
      var term = $('#search_term').val();
      $("table.searchable tbody tr td:not(.last):not(:Contains('"+term+"'))").parents("tr").hide();
      $("table.searchable tbody tr td:not(.last):Contains('"+term+"')").parents("tr").show();
      $("table.searchable tbody tr:visible:even").removeClass("light").addClass("dark")
      $("table.searchable tbody tr:visible:odd").removeClass("dark").addClass("light")
      return false;
    }
    else{
      var term = $('#search_term').val();
      $("table.searchable tbody tr td:first-child:not(:Contains('"+term+"'))").parents("tr").hide();
      $("table.searchable tbody tr td:first-child:Contains('"+term+"')").parents("tr").show();
      $("table.searchable tbody tr:visible:even").removeClass("light").addClass("dark")
      $("table.searchable tbody tr:visible:odd").removeClass("dark").addClass("light")
      return false;
    }
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
    if($('span.checkStrand input:checkbox:checked').length > 0){
      $('.strandsPresent').show();
      $('.noStrands').hide();
    }
    else{
      $('.noStrands').show();
      $('.strandsPresent').hide();
    }
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
    toggleDependencies(this);
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

  $('.directorateCheckbox :checkbox').click(function(){
    $(this).parents('form').submit();
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


  $(document).on("click", ".colorbox", function(e){
    $.colorbox({'href': $(this).data("path"),
                      scrolling: false,
                      onComplete: function(){$('.cancelLink').click(function(){$.colorbox.close();} ) }} );
    e.preventDefault();
  });
  $('.inline').click(function(){
    $(this).colorbox({'inline': true});
  })


  $(document).on('ajax:complete', '.lightboxForm', function(data, status, xhr) {
    // $('#cboxLoadedContent').html(status);
    // console.log();
    // alert(status);
    console.log(status.responseText)
    if(status.responseText == "form load successful"){
      window.location.reload();
    } else {
      // console.log(data);
      $.colorbox({html: status.responseText});
    }
    // console.log(data);
    // alert(status);
    // alert(xhr);
  });

  $('#activity_service_area_id').change(function(){
    $("#activity_approver_email").val(
      $('#activity_service_area_id option:selected').data("email")
    );
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
        if( $("#"+question).find('.issue').filter(function() { return $(this).css("display") != "none" }).size() > 0 ) {
          $(element).find('[value="1"]').attr('selected', 'selected');
          alert('Please delete all issues before changing this option');
        } else {
          $("#"+question).hide();
        }
      }
      toggleDependencies($("#"+question + " select"));
    });
  }
}
