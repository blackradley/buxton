$(document).ready(function(){

  $('.checkbox :checkbox').click(function(){
    $.post($(this).data("path"));
  });
  
});