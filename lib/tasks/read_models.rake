namespace :read_models do
  desc "Create Project Read Models From the Stream of events"
  task create_project: :environment do
    events = Rails.configuration.event_store.read.of_type([Conversations::Events::ProjectCreated, Conversations::Events::ProjectStateChanged])

    read_model_config = ProjectReadModel::Configuration.new

    events.each do |event|
      case event
      when Conversations::Events::ProjectCreated
        read_model_config.created(event)        
      when Conversations::Events::ProjectStateChanged
        read_model_config.state_changed(event)        
      end
    end
  end
end
