var changed = []

function setChanged (elem) {
  if (changed.include(elem.id)) {
    return
  } else {
    changed.push(elem.id);
  }
}

function disableUnchanged() {
  var inputs = $('help_form').getElements();
  inputs.each(function(elem){
    if (!changed.include(elem.id)) {
      elem.disable();
    }
  });
}