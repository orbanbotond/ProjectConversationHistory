class ProjectStateForm
  include ActiveModel::Model

  attr_accessor :state
  attr_accessor :id

  validates :state, presence: true
end

