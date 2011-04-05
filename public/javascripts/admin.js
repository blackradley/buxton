$(document).ready(function(){

  $('.checkbox :checkbox').click(function(){
    if ($(this).attr('id').indexOf('retired') >= 0)
      $(this).parents('tr').fadeOut();
    $.post($(this).data("path"));
  });
  
  $('table .edit.action').colorbox();
  
});