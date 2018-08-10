
function initializeSongObject(html_id, url){
  var stageW = '35';
  var stageH = '35';
  var cacheBuster = Date.parse(new Date());
  var flashvars = {};
  var params = {};
  params.bgcolor = '#ffffff';
  flashvars.componentWidth = stageW;
	flashvars.componentHeight = stageH;
  flashvars.stageW = stageW;
  flashvars.stageH = stageH;
  flashvars.pathToFiles = '';
  flashvars.xmlPath = url;
  flashvars.wmode= 'transparent';
  swfobject.embedSWF('/javascripts/song_player/song_player.swf?t='+cacheBuster, html_id, stageW, stageH, '9.0.124', '/javascripts/song_player/expressInstall.swf', flashvars, params);
}
