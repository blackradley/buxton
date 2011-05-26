$(document).ready(function(){

  $('.checkbox :checkbox').click(function(){
    // if ($(this).attr('id').indexOf('retired') >= 0)
    //   $(this).parents('tr').fadeOut();
    $.post($(this).data("path"));
  });
  
  $('table .edit.action, .new_user').colorbox();
  
  
  $('.lightboxForm').live('ajax:success', function(data, status, xhr) {
    // $('#cboxLoadedContent').html(status);
    // alert(data);
    if (status.substring(5,0)!='try {')
      $.colorbox({html: status});
    // console.log(data);
    // alert(status);
    // alert(xhr);
  });
  
});