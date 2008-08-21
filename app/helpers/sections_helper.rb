#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#

module SectionsHelper

  def insert_help(section, strand, question)
    strand = strand.to_sym
    divId="help_#{section}_#{strand}_#{question}"
    %Q[<div class="helper">#{link_to_function image_tag("icons/help.gif"), "Element.toggle('#{divId}')"}</div>
      <span id="#{divId}" class="toggleHelp" style="display:none;">#{$help[section][strand][question][0]}</span>]
  end
   
  def split_long_strings(text)
    text.to_s.dup.gsub(/\S{35}/, "\0\n")
  end
  
  def format_attachment(text)
    text = text.to_s.dup
    text = h(split_long_strings(text))
    text.gsub!(/\r\n?/, "\n")  # \r\n and \r -> \n
    text.gsub!(/\n/, '<br />') # 1 newline   -> br
    text
  end
  
  def tooltip_if_comment(comment)
    return "" if (comment.nil? || comment.blank?)
    image_tag = image_tag('icons/comment.gif', :id => comment.html_id)
    tip = "new Tip('#{comment.html_id}', '#{escape_javascript(format_attachment(comment.contents))}');"
    tooltip_tag = content_tag('script', tip, :type => 'text/javascript')
    return image_tag + tooltip_tag
  end
  
end