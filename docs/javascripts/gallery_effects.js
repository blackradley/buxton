function scrollGalleryLeft() {
  $('gallerySliderPreviews').childElements().each(function(elm){
    new Effect.Move(elm, { x: 122, y: 0 })
  });
}

function scrollGalleryRight() {
  $('gallerySliderPreviews').childElements().each(function(elm){
    new Effect.Move(elm, { x: -122, y: 0 })
  });
}

function displayImage(image_id) {
  var preview_container = $('preview_'+image_id);
  $('gallerySliderMain').innerHTML = preview_container.down('.gallerySliderMain').innerHTML;
  $('gallerySliderDescription').innerHTML = preview_container.down('.gallerySliderDescription').innerHTML;
	selectThumbnail(image_id);
}

function selectThumbnail(image_id){
	selectedClass = '.selected';
	var current = $A($$(selectedClass))[0];
	if(current){
	   current.removeClassName('selected');
	 }
	$(image_id).addClassName('selected');
}