module Conversations
  module Commands
    class CreateProject < Infra::Command
      attribute :id, Infra::Types::Strict::String
      attribute :title, Infra::Types::Coercible::String
    end

    class ChangeProjectState < Infra::Command
      attribute :id, Infra::Types::Strict::String
      attribute :new_state, Infra::Types::Coercible::String
    end

    class CommentProject < Infra::Command
      attribute :id, Infra::Types::Strict::String
      attribute :comment, Infra::Types::Strict::String
    end
  end
end
