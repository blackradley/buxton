var LOCALE = 'en'
var INTRO_WIDTH = 105
var BANNER_WIDTH = 90
var LOGO_WIDTH = 68
var COPYRIGHT_WIDTH = 113
var MENU_WIDTH = 77
var PREVIEW_WIDTH = 130
var GALLERY_WIDTH = 137
var CONTACT_WIDTH = 130
var TESTIMONIAL_WIDTH = 176
var NEWS_WIDTH = 141
var NEWS_ITEM_WIDTH = 87
var SHOP_WIDTH = 137
var CONTENT_WIDTH = 67
var LANGUAGES_WIDTH = 33
var DEFAULT_WIDTH = 33

var ADD_IMAGES_BUTTON_WIDTH = "100";
var NEW_SHOP_IMAGE_BUTTON_WIDTH = "120";

function t (key, variable) {
  if (variable)
    return tValues[key].gsub('PLACEHOLDER', variable);
  else
    return tValues[key];
}

var tValues = new Array();
tValues['set_default'] = 'Set Language';
tValues['add'] = 'Add';
tValues['remove'] = 'Remove';
tValues['loading'] = 'Loading';
tValues['empty_logo'] = 'Logo text cannot be empty';
tValues['menu_title.colours'] = 'Colours & Fonts';
tValues['menu_title.order'] = 'Edit Menu - Page Order';
tValues['menu_title.rename'] = 'Edit Menu - Rename Pages';
tValues['text_title.main_colours'] = 'Main Colours & Fonts';
tValues['text_title.headings'] = 'Headings';
tValues['text_title.links'] = 'Links';
tValues['page_length_error'] = 'All page titles must be between 2 and 50 characters.';
tValues['quick_tips'] = 'quick tips';

tValues['thumbnail'] = "Creating thumbnail...";
tValues['uploading'] = "Uploading...";
tValues['thumb_complete'] = "Thumbnail Created.";
tValues['swfupload_complete'] = "Upload complete.";
tValues['swfupload_cancelled'] = "Cancelled";
tValues['swfupload_stopped'] = "Stopped";
tValues['swfupload_uploaded'] = "Image has been Uploaded.";
tValues['swf_error.too_many'] = "You have attempted to queue too many files.";
tValues['swf_error.zero_byte'] = "File ( PLACEHOLDER ) has zero byte";
tValues['swf_error.too_big'] = "File ( PLACEHOLDER ) exceeds size limit";
tValues['swf_error.invalid'] = "File ( PLACEHOLDER ) has invalid filetype";
tValues['swf_error.unidentified'] = "Unidentified problem with uploading file : ( PLACEHOLDER )";
tValues['browse'] = 'browse';
tValues['add_images'] = 'add images';
tValues['upload_image'] = 'upload new image';
tValues['upload'] = 'upload';
tValues['image'] = 'Image';
tValues['of'] = 'of';