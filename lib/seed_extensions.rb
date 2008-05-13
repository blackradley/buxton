module Seed
  def add_seed(class_name, variables = nil, &block)
    print "Adding seed data for #{(find_class class_name).to_s} with"
    variables.each do |key, value|
      print " #{key.to_s} => #{value}"
    end
    object_to_create = find_class class_name
    instance_of_object = object_to_create.new(variables)
    possible_parent_list = possible_parents instance_of_object
    parent_instance = self unless possible_parent_list.select{|parent| parent == self.class.to_s}.blank?
    instance_of_object.send("#{parent_instance.class.to_s.downcase.to_sym}=", parent_instance) if parent_instance
    instance_of_object.instance_eval(&block) if block
    instance_of_object.save
    puts ""
  end

  def add_values(hash)
    self.update_attributes!(hash)
  end

  def add_value(hash)
    self.update_attributes(hash)
  end
  #warning, remove seed does not remove children elements unless they have dependent destroy set on them.
  def remove_seed(class_name, variables)
    print "Removing Seed Data for #{(find_class class_name).to_s} with"
    variables.each do |key, value|
      print " #{key} => #{value}"
    end
    object_to_remove = find_class class_name
    to_delete = object_to_remove.send("find_by_#{variables.keys.join('_and_')}".to_sym, variables.values)
    to_delete.destroy if to_delete
    puts ""
  end

  def has_parent(class_name, variables)
    object_to_create = find_class class_name
    parent_instance = object_to_create.send("find_by_#{variables.keys.join('_and_')}".to_sym, variables.values)
    self.update_attributes!("#{parent_instance.class.to_s.underscore}_id" => parent_instance.id)
  end
#Methods to be re-written!
  def find_class(class_name)
    class_name = class_name.to_s.singularize.camelize
    object_to_create = eval(class_name)
    return object_to_create
  end

  def possible_parents(object)
    parents = object.attributes.keys.delete_if{|attribute| !(attribute.to_s.include? '_id')}
    parents.map!{|parent| parent.chop.chop.chop.camelize}
  end
end
