class Function < ActiveRecord::Base
  belongs_to :organisation
  def state
    read_attribute(:relevance01) +
    read_attribute(:relevance02) +
    read_attribute(:relevance03) +
    read_attribute(:relevance04) +
    read_attribute(:relevance05) +
    read_attribute(:relevance06)
  end
end
