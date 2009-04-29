module FixInvalidChars
  
  def fix_field(field)
    return field unless field.class == String
    field.gsub!("‘", "'")
    field.gsub!("’", "'")
    field.gsub!("“", '"')
    field.gsub!("”", '"')
    field.gsub!('–', "-")
    field
  end
end