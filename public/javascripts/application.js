// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Show or hide
function toggleHelp(node){
  if (node.tagName && node.tagName.toLowerCase() == 'div')
    node.style.display = (node.style.display == 'block') ? 'none' : 'block';
}

function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.directorate').hide();
}

function mark_for_issue_destroy(element) {
	$(element).next('.issue_destroy').value = 1;
	$(element).up('.issue').hide();
}