module Conversations
  module Events
    class ProjectCreated < Infra::Event
      attribute :id, Infra::Types::Strict::String
      attribute :title, Infra::Types::Coercible::String
      attribute :initial_state, Infra::Types::Coercible::String
    end

    class ProjectStateChanged < Infra::Event
      attribute :id, Infra::Types::Strict::String
      attribute :old_state, Infra::Types::Coercible::String
      attribute :new_state, Infra::Types::Coercible::String
    end

    class ProjectCommented < Infra::Event
      attribute :id, Infra::Types::Strict::String
      attribute :comment, Infra::Types::Strict::String
    end
  end
end
