var changed = []

function setChanged (elem) {
  if (changed.include(elem)) {
    return
  } else {
    changed.push(elem);
  }
}

function disableUnchanged() {
  var inputs = $('help_form').getElements();
  inputs.each(function(elem){
    if (!changed.include(elem)) {
      elem.disable();
    }
  });
}