class ProjectsController < ApplicationController
  def new
    @project_form = ProjectForm.new
  end

  def state_change
    @project_state_form = ProjectStateForm.new project_state_params
    if @project_state_form.valid?
      command_bus.(Conversations::Commands::ChangeProjectState.new(id: params[:id],
                                                          new_state: @project_state_form.state))

      @project = ProjectReadModel.find params[:id]
      render partial: 'new_project_state_link'
    else
      render :new_state_change, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def new_state_change
    @project_state_form = ProjectStateForm.new id: params[:id]
  end

  def show
    @project = ProjectReadModel.find params[:id]

    @history = ProjectHistoryReadModel.where project_id: params[:id]
  end

  def create
    @project_form = ProjectForm.new project_params
    if @project_form.valid?
      command_bus.(Conversations::Commands::CreateProject.new(id: SecureRandom.uuid,
                                                          title: @project_form.title))
      render partial: 'new_project_link'
   else
      render :new, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def index
    @projects = ProjectReadModel.all
  end

  private

  def project_params
    request.parameters[:project_form]
  end

  def project_state_params
    request.parameters[:project_state_form]
  end
end
