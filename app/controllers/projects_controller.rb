class ProjectsController < ApplicationController
  def new
    @project_form = ProjectForm.new
  end

  def show
    @project = nil

    repository = Infra::AggregateRootRepository.new(Rails.configuration.event_store)
    repository.with_aggregate(Conversations::Project, params[:id]) do |project|
      @project = project
    end  

    stream_name = "#{Conversations::Project}$#{params[:id]}"
    history_events = Rails.configuration.event_store.read.stream(stream_name).of_type([Conversations::Events::ProjectCommented, Conversations::Events::ProjectStateChanged])

    converter = {
      Conversations::Events::ProjectStateChanged => -> (event) { "State Changed To: #{event.data[:new_state]} From: #{event.data[:old_state]}" },
      Conversations::Events::ProjectCommented => -> (event) { "Commented: #{event.data[:comment]}"}
    }

    @history = history_events.map { |event|
      { 
        timestamp: event.metadata[:timestamp],
        action: converter[event.class].call(event)
      }
    }
  end

  def create
    @project_form = ProjectForm.new project_params
    if @project_form.valid?
      command_bus.(Conversations::Commands::CreateProject.new(id: SecureRandom.uuid,
                                                          title: @project_form.title))
      redirect_to projects_path
    else
      render :new, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def index
    events = Rails.configuration.event_store.read.of_type("Conversations::Events::ProjectCreated")

    @projects = events.map do |event|
      {
        id: event.data[:id],
        title: event.data[:title]
      }
    end
  end

  def project_params
    request.parameters[:project_form]
  end
end
