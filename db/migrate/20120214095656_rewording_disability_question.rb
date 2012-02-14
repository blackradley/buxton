class RewordingDisabilityQuestion < ActiveRecord::Migration
  def self.up
    Question.where(:name => "purpose_disability_3").each do |q|
      q.update_attributes(:raw_label => "Does this \#{function_policy_substitution} have any relevance to individuals with a disability?" )
    end
  end

  def self.down
  end
end
