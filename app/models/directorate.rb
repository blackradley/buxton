#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Directorate < ActiveRecord::Base
  belongs_to :organisation
  # has_one :directorate_manager, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :directorate_strategies, :dependent => :destroy
  
  validates_uniqueness_of :name, :scope => :organisation_id
  validates_presence_of :name# , :directorate_manager
  validates_associated :activities
  
  after_update :save_directorate_strategies

  attr_accessor :should_destroy
  
  include FixInvalidChars
  
  before_save :fix_name
  
  def fix_name
    self.name = fix_field(self.name)
  end

  def should_destroy?
    should_destroy.to_i == 1
  end

  def directorate_strategy_attributes=(directorate_strategy_attributes)
    directorate_strategy_attributes.each do |attributes|
      next if attributes[:name].blank?
      if attributes[:id].blank?
        directorate_strategies.build(attributes)
      else
        directorate_strategy = directorate_strategies.detect { |d| d.id == attributes[:id].to_i }
        attributes.delete(:id)
        directorate_strategy.attributes = attributes
      end
    end
  end

  def save_directorate_strategies
    self.directorate_strategies.each do |ds|
      if ds.should_destroy?
        ds.destroy
      else
        ds.save(false)
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
