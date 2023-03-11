class ProjectReadModel < ActiveRecord::Base
  class Configuration
    def call(cqrs)
      @cqrs = cqrs

      subscribe_and_link_to_stream(
        ->(event) { created(event) },
        [Conversations::Events::ProjectCreated]
      )
      subscribe_and_link_to_stream(
        ->(event) { state_changed(event) },
        [Conversations::Events::ProjectStateChanged]
      )
    end

    def created(event)
      ProjectReadModel.find_or_create_by id: event.data.fetch(:id) do |project_rm|
        project_rm.title = event.data.fetch(:title)
        project_rm.status = event.data.fetch(:initial_state)
      end
    end

    def state_changed(event)
      project_rm = ProjectReadModel.find_by id: event.data.fetch(:id)
      project_rm.update(status: event.data.fetch(:new_state))
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
      @cqrs.link_event_to_stream(event, "Projects$all")
    end

    def subscribe(handler, events)
      @cqrs.subscribe(handler, events)
    end
  end

  after_create_commit -> { broadcast_append_to 'projects_list', partial: "project_read_models/project_read_model", locals: { project_read_model: self } }
  after_update_commit -> { broadcast_replace_to 'project', partial: "project_read_models/project_read_model", locals: { project_read_model: self } }
end
