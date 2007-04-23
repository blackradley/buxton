// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Show or hide
function toggleHelp(node){
  if (node.tagName && node.tagName.toLowerCase() == 'div')
    node.style.display = (node.style.display == 'block') ? 'none' : 'block';
}