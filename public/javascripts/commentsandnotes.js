function edit_comment(question_id){
  if(trim_using_recursion(document.getElementById(question_id + '_comment').innerHTML).length > 0){
    Element.toggle(question_id + '_comment_view');
    Element.toggle(question_id + '_comment_form');
    $(question_id + '_comment_fill_in').focus();
  }
  else{
   document.getElementById(question_id + '_comment_new').style.display = 'block';
   document.getElementById(question_id + '_comment_form').style.display = 'none';
   document.getElementById(question_id + '_comment_view').style.display = 'none';    
  }
}
function new_comment(question_id){
  Element.toggle(question_id + '_comment_new');
  Element.toggle(question_id + '_comment_form');
  $(question_id + '_comment_fill_in').focus();
}
function cancel_comment(question_id){
  if(trim_using_recursion(document.getElementById(question_id + '_comment').innerHTML).length == 0){
   document.getElementById(question_id + '_comment_new').style.display = 'block';
   document.getElementById(question_id + '_comment_form').style.display = 'none';
    document.getElementById(question_id + '_comment_view').style.display = 'none';
  }
  else{
    edit_comment(question_id);
  }
}
function trim_using_recursion(str) 
  {  if(str.charAt(0) == " "|| str.charAt(0) == '\n' || str.charAt(0) == '\t')
  {  str = trim_using_recursion(str.substring(1));
  }
  if (str.charAt(str.length-1) == " ")
   {  str = trim_using_recursion(str.substring(0,str.length-1));
  }
  return str;
}

function edit_note(question_id){
  if(trim_using_recursion(document.getElementById(question_id + '_note').innerHTML).length > 0){
    Element.toggle(question_id + '_note_view');
    Element.toggle(question_id + '_note_form');
    $(question_id + '_note_fill_in').focus();
  }
  else{
    document.getElementById(question_id + '_note_new').style.display = 'block';
    document.getElementById(question_id + '_note_form').style.display = 'none';
    document.getElementById(question_id + '_note_view').style.display = 'none';
  }
}
function new_note(question_id){
  Element.toggle(question_id + '_note_new');
  Element.toggle(question_id + '_note_form');
  $(question_id + '_note_fill_in').focus();
}
function cancel_note(question_id){
  if(trim_using_recursion(document.getElementById(question_id + '_note').innerHTML).length == 0){
   document.getElementById(question_id + '_note_new').style.display = 'block';
   document.getElementById(question_id + '_note_form').style.display = 'none';
    document.getElementById(question_id + '_note_view').style.display = 'none';
  }
  else{
    edit_note(question_id);
  }
}
