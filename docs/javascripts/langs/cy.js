var LOCALE = 'cy'
var INTRO_WIDTH = 185
var BANNER_WIDTH = 97
var LOGO_WIDTH = 83
var COPYRIGHT_WIDTH = 153
var MENU_WIDTH = 123
var PREVIEW_WIDTH = 112
var GALLERY_WIDTH = 202
var CONTACT_WIDTH = 262
var TESTIMONIAL_WIDTH = 192
var NEWS_WIDTH = 216
var NEWS_ITEM_WIDTH = 127
var SHOP_WIDTH = 147
var CONTENT_WIDTH = 97
var LANGUAGES_WIDTH = 47
var DEFAULT_WIDTH = 47

var ADD_IMAGES_BUTTON_WIDTH = "160";
var NEW_SHOP_IMAGE_BUTTON_WIDTH = "150";

function t (key, variable) {
  if (variable)
    return tValues[key].gsub('PLACEHOLDER', variable);
  else
    return tValues[key];
}

var tValues = new Array();
tValues['set_default'] = 'Gosod Iaith';
tValues['add'] = 'Ychwanegu';
tValues['remove'] = 'Dileu';
tValues['loading'] = 'Llwytho';
tValues['empty_logo'] = 'Ni fedrith testun logo fod yn wag';
tValues['menu_title.colours'] = 'Lliwiau a Ffontiau';
tValues['menu_title.order'] = 'Golygu Dewislen - Trefn Tudalen';
tValues['menu_title.rename'] = 'Golygu Dewislen - Ailenwi Tudalennau';
tValues['text_title.main_colours'] = 'Prif Liwiau a Ffontiau';
tValues['text_title.headings'] = 'Pennawdau';
tValues['text_title.links'] = 'Dolenni';
tValues['page_length_error'] = "Mae'n rhaid i bob teitl tudalen fod rhwng 2 a 50 nod.";
tValues['quick_tips'] = 'cynghorion cyflym';

tValues['thumbnail'] = "Yn creu mân-lun...";
tValues['uploading'] = "Yn uwchlwytho...";
tValues['thumb_complete'] = "Mân-lun wedi'i greu.";
tValues['swfupload_complete'] = "Pob llun wedi cael ei dderbyn";
tValues['swfupload_cancelled'] = "Wedi hepgor";
tValues['swfupload_stopped'] = "Wedi atal";
tValues['swfupload_uploaded'] = "Llun wedi cael ei uwchlwytho";
tValues['swf_error.too_many'] = "You have attempted to queue too many files.Rydych wedi trio ciwio gormod o ffeiliau";
tValues['swf_error.zero_byte'] = "mae gan y ffeil ( PLACEHOLDER ) beit sero";
tValues['swf_error.too_big'] = "mae'r ffeil yn ( PLACEHOLDER ) fwy na'r maint uchafswm";
tValues['swf_error.invalid'] = "mae'r ffeil ( PLACEHOLDER ) yn fath ffeil annilys";
tValues['swf_error.unidentified'] = "Problem anhysbys gyda uwchlwytho ffeil : ( PLACEHOLDER )";
tValues['browse'] = 'pori';
tValues['add_images'] = 'ychwanegu lluniau';
tValues['upload_image'] = 'uwchlwytho llun newydd';
tValues['upload'] = 'uwchlwytho';
tValues['image'] = 'Llun';
tValues['of'] = 'of';