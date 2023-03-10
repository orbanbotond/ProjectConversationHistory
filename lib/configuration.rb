require_relative "./infra/infra"
require_relative "./conversations/conversations"

class Configuration
  def call(cqrs)
    enable_domains(cqrs)
  end

  private

  def enable_domains(cqrs)
    Conversations::Configuration.new.call(cqrs)
  end
end
