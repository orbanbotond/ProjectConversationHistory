class CommentForm
  include ActiveModel::Model

  attr_accessor :comment
  attr_accessor :project_id

  validates :comment, presence: true
end

