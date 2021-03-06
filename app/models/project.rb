#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Project < ActiveRecord::Base
  attr_protected
   has_and_belongs_to_many :activities
   belongs_to :organisation
   has_one :project_manager
   has_many :project_strategies, :dependent => :destroy

   validates_uniqueness_of :name, :scope => :organisation_id
   validates_presence_of :name, :project_manager
   validates_associated :activities

   after_update :save_project_strategies

   attr_accessor :should_destroy

   include FixInvalidChars

   before_save :fix_name

   def fix_name
     self.name = fix_field(self.name)
   end

   def should_destroy?
     should_destroy.to_i == 1
   end

   def project_strategy_attributes=(project_strategy_attributes)
     project_strategy_attributes.each do |attributes|
       next if attributes[:name].blank?
       if attributes[:id].blank?
         project_strategies.build(attributes)
       else
         project_strategy = project_strategies.detect { |d| d.id == attributes[:id].to_i }
         attributes.delete(:id)
         project_strategy.attributes = attributes
       end
     end
   end

   def save_project_strategies
     self.project_strategies.each do |ps|
       if ps.should_destroy?
         ps.destroy
       else
         ps.save(false)
       end
     end
   end


  def results_table
    Organisation.results_table(self)
  end

  def can_be_edited_by?(user_)
    user_.class == Administrator
  end

  def self.can_be_viewed_by?(user_)
    user_.class == Administrator
  end

end
