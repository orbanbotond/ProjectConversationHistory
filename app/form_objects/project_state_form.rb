class ProjectStateForm
  include ActiveModel::Model

  attr_accessor :state

  validates :state, presence: true
end

