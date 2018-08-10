function showVideoGalleryLightbox(title){
  new Effect.Appear($('videoGalleryMask'), { duration: 0.2,  from: 0.0, to: 0.8});
  $('videoLightbox').show();
  $('caption').innerHTML = title;
  var obj = $('videoLightbox');
  if (navigator.appVersion.match(/MSIE 6/)) {
    $('outerVideoContainer').setStyle({'width' : "400px"});
    $('outerVideoContainer').setStyle({'height' : "100px"});
    $('videoLocation').innerHTML = noIE6();
    window.scrollTo(0);
  } else {
    $('outerVideoContainer').setStyle({'width' : (obj.down('object').getWidth()+20) + "px"});
    // $('videoLocation').setStyle({'height' : obj.getHeight() + "px"});
    new_height = (document.viewport.getHeight()/2.0 - obj.getHeight()/2.0) + "px";
    $('outerVideoContainer').setStyle({'margin-top': new_height}); 
  }
}

function closeLightbox(){
  $('videoGalleryMask').hide();
  $('videoLightbox').hide();  
  $('videoLocation').innerHTML = "";
}

function noIE6 () {
  return "<div style='border: 1px solid #F7941D; background: #FEEFDA; text-align: center; clear: both; height: 75px; position: relative;'><div style='position: absolute; right: 3px; top: 3px; font-family: courier new; font-weight: bold;'><a href='#' onclick='javascript:this.parentNode.parentNode.style.display=\"none\"; return false;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-cornerx.jpg' style='border: none;' alt='Close this notice'/></a></div><div style='width: 640px; margin: 0 auto; text-align: left; padding: 0; overflow: hidden; color: black;'><div style='width: 75px; float: left;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-warning.jpg' alt='Warning!'/></div><div style='width: 275px; float: left; font-family: Arial, sans-serif;'><div style='font-size: 14px; font-weight: bold; margin-top: 12px;'>You are using an outdated browser</div><div style='font-size: 12px; margin-top: 6px; line-height: 12px;'>For a better experience using this site, please upgrade to a modern web browser.</div></div><div style='width: 75px; float: left;'><a href='http://www.firefox.com' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-firefox.jpg' style='border: none;' alt='Get Firefox 3.5'/></a></div><div style='width: 75px; float: left;'><a href='http://www.browserforthebetter.com/download.html' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-ie8.jpg' style='border: none;' alt='Get Internet Explorer 8'/></a></div><div style='width: 73px; float: left;'><a href='http://www.apple.com/safari/download/' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-safari.jpg' style='border: none;' alt='Get Safari 4'/></a></div><div style='float: left;'><a href='http://www.google.com/chrome' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-chrome.jpg' style='border: none;' alt='Get Google Chrome'/></a></div></div></div>"
}

function replaceVideoThumbnail(){
  if($('video_gallery_video_embed_code').value.match(/http:\/\/www.youtube.com\/v\/(\d*\w*)/)){
    var vid = $('video_gallery_video_embed_code').value.match(/http:\/\/www.youtube.com\/v\/(\d*\w*)/)[1];
    var img_path = "http://img.youtube.com/vi/" + vid + "/default.jpg";
    $('image').down('img').src = img_path;
  }
}