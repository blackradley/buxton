class Function < ActiveRecord::Base
  belongs_to :organisation
  def state
    read_attribute(:relevance01).nil? ? 0 : 1 +
    read_attribute(:relevance02).nil? ? 0 : 1 +
    read_attribute(:relevance03).nil? ? 0 : 1 +
    read_attribute(:relevance04).nil? ? 0 : 1 +
    read_attribute(:relevance05).nil? ? 0 : 1 +
    read_attribute(:relevance06).nil? ? 0 : 1
  end
end
