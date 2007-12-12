#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
module SectionsHelper
  def insert_help(section, strand, question)
    strand = strand.to_sym
    divId="help_#{section}_#{strand}_#{question}"
    %Q[<div class="helper">#{link_to_function image_tag("icons/help.gif"), "Element.toggle('#{divId}')"}</div>
      <span id="#{divId}" class="toggleHelp" style="display:none;">#{$help[section][strand][question][0]}</span>]
   end
end
