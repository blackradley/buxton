function textResize(size){
  switch(size*1) {
    case 0: 
      $('content').removeClassName('bigger');
      $('copyright').removeClassName('bigger');
      $('footer').removeClassName('bigger');
      $('menu').removeClassName('bigger');
      $('topmenu').removeClassName('bigger');
      $('content').removeClassName('biggest');
      $('copyright').removeClassName('biggest');
      $('footer').removeClassName('biggest');
      $('menu').removeClassName('biggest');
      $('topmenu').removeClassName('biggest');
      break;
    case 1: 
      $('content').addClassName('bigger');
      $('copyright').addClassName('bigger');
      $('footer').addClassName('bigger');
      $('menu').addClassName('bigger');
      $('topmenu').addClassName('bigger');
      $('content').removeClassName('biggest');
      $('copyright').removeClassName('biggest');
      $('footer').removeClassName('biggest');
      $('menu').removeClassName('biggest');
      $('topmenu').removeClassName('biggest');
      break;
    case 2: 
      $('content').removeClassName('bigger');
      $('copyright').removeClassName('bigger');
      $('footer').removeClassName('bigger');
      $('menu').removeClassName('bigger');
      $('topmenu').removeClassName('bigger');
      $('content').addClassName('biggest');
      $('copyright').addClassName('biggest');
      $('footer').addClassName('biggest');
      $('menu').addClassName('biggest');
      $('topmenu').addClassName('biggest');
      break;
  }
  
  createCookie("textsizestyle", size, 365);
}







function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  }
  else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}
 
function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}
