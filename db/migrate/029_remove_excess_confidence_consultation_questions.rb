#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class RemoveExcessConfidenceConsultationQuestions < ActiveRecord::Migration
  def self.up
	  remove_column :functions, :confidence_consultation_gender_8
	  remove_column :functions, :confidence_consultation_race_8
	  remove_column :functions, :confidence_consultation_disability_8
	  remove_column :functions, :confidence_consultation_age_8
	  remove_column :functions, :confidence_consultation_sexual_orientation_8
	  remove_column :functions, :confidence_consultation_faith_8
  end

  def self.down
	add_column :functions, :confidence_consultation_gender_8, :text
	add_column :functions, :confidence_consultation_race_8, :text
	add_column :functions, :confidence_consultation_disability_8, :text
	add_column :functions, :confidence_consultation_age_8, :text
	add_column :functions, :confidence_consultation_sexual_orientation_8, :text
	add_column :functions, :confidence_consultation_faith_8, :text
  end
end
