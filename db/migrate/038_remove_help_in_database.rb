class RemoveHelpInDatabase < ActiveRecord::Migration
  def self.up
    remove_column :organisations, "strategies_description"
    remove_column :organisations, "strategies_help"
    remove_column :organisations, "impact_groups_description"
    remove_column :organisations, "impact_groups_help"
    remove_column :organisations, "good_equality_groups_description"
    remove_column :organisations, "good_equality_groups_help"
    remove_column :organisations, "bad_equality_groups_description"
    remove_column :organisations, "bad_equality_groups_help"
    remove_column :organisations, "approval_help"
  end

  def self.down
    add_column :organisations, "strategies_description",           :string, :default => "Which of the priorities (below) are you helping to deliver?"
    add_column :organisations, "strategies_help",                  :text
    add_column :organisations, "impact_groups_description",        :string,   :default => "Which of these groups are you having an impact on?"
    add_column :organisations, "impact_groups_help",               :text
    add_column :organisations, "good_equality_groups_description", :string,   :default => "If the function were performed well..."
    add_column :organisations, "good_equality_groups_help",        :text
    add_column :organisations, "bad_equality_groups_description",  :string,   :default => "If the function were performed badly..."
    add_column :organisations, "bad_equality_groups_help",         :text
    add_column :organisations, "approval_help",                    :text
  end
end
