#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Directorate < ActiveRecord::Base
  has_many :activities, :dependent => :destroy
  has_many :service_areas, :dependent => :destroy
  belongs_to :cop, :class_name => "User"
  validates_uniqueness_of :name, :abbreviation, :creator_id
  validates_presence_of :name, :abbreviation
  validates_presence_of :creator_email, :cop_email, :message => "must be a valid user"
  # validates_associated :cop
  belongs_to :creator, :class_name => "User"
  
  attr_accessor :should_destroy
  
  include FixInvalidChars
  
  before_save :fix_name
  
  def fix_name
    self.name = fix_field(self.name)
  end
  
  def cop_email
    if self.cop
      self.cop.email
    else
      ""
    end
  end
  
  def cop_email=(email)
    if user = User.live.find_by_email(email)
      self.cop_id = user.id
    else
      self.cop_id = nil
    end
  end
  
  def creator_email
    if self.creator
      self.creator.email
    else
      ""
    end
  end
  
  def creator_email=(email)
    if user = User.creator.find_by_email(email)
      self.creator_id = user.id
    else
      self.creator_id = nil
    end
  end
  

  def should_destroy?
    should_destroy.to_i == 1
  end

  # def directorate_strategy_attributes=(directorate_strategy_attributes)
  #     directorate_strategy_attributes.each do |attributes|
  #       next if attributes[:name].blank?
  #       if attributes[:id].blank?
  #         directorate_strategies.build(attributes)
  #       else
  #         directorate_strategy = directorate_strategies.detect { |d| d.id == attributes[:id].to_i }
  #         attributes.delete(:id)
  #         directorate_strategy.attributes = attributes
  #       end
  #     end
  #   end

  # def save_directorate_strategies
  #     self.directorate_strategies.each do |ds|
  #       if ds.should_destroy?
  #         ds.destroy
  #       else
  #         ds.save(false)
  #       end
  #     end
  #   end

  # def results_table
  #     Organisation.results_table(self)
  #   end  
  
  def can_be_edited_by?(user_)
    user_.class == Administrator
  end
  
  def self.can_be_viewed_by?(user_)
    user_.class == Administrator
  end
end
