class CommentsController < ApplicationController
	def new
		@comment_form = CommentForm.new project_id: params[:project_id]
	end

	def create
		@comment_form = CommentForm.new comment_params
    if @comment_form.valid?
      command_bus.(Conversations::Commands::CommentProject.new(id: @comment_form.project_id,
			                                                         comment: @comment_form.comment))
      @project = ProjectReadModel.find params[:project_id]
      render partial: 'projects/new_project_comment_link'
    else
    	render :new
    end
	end

private
	def comment_params
    request.parameters[:comment_form]
	end
end
