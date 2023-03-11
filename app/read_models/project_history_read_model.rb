class ProjectHistoryReadModel < ActiveRecord::Base
  class Configuration
    def call(cqrs)
      @cqrs = cqrs

      subscribe_and_link_to_stream(
        ->(event) { commented(event) },
        [Conversations::Events::ProjectCommented]
      )
      subscribe_and_link_to_stream(
        ->(event) { state_changed(event) },
        [Conversations::Events::ProjectStateChanged]
      )
    end

    def commented(event)
      ProjectHistoryReadModel.create project_id: event.data.fetch(:id),
                                     action: "Commented: #{event.data[:comment]}",
                                     created_at: event.metadata[:timestamp]
    end

    def state_changed(event)
      ProjectHistoryReadModel.create project_id: event.data.fetch(:id),
                                     action: "State Changed To: #{event.data[:new_state]} From: #{event.data[:old_state]}",
                                     created_at: event.metadata[:timestamp]
    end

    private

    def subscribe_and_link_to_stream(handler, events)
      link_and_handle = ->(event) do
        link_to_stream(event)
        handler.call(event)
      end
      subscribe(link_and_handle, events)
    end

    def link_to_stream(event)
      @cqrs.link_event_to_stream(event, "ProjectHistory$#{event.data[:id]}")
    end

    def subscribe(handler, events)
      @cqrs.subscribe(handler, events)
    end
  end

  self.table_name = "project_histories"

  after_create_commit -> { broadcast_append_to 'project', partial: "project_history_read_models/project_history_read_model", locals: { project_history_read_model: self } }
end
