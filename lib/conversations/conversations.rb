require_relative 'commands'
require_relative 'events'
require_relative 'project'

module Conversations
	class CreateProjectHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Project, command.id) do |project|
        project.create(command)
      end
    end
	end

	class ChangeProjectStateHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Project, command.id) do |project|
        project.change_state(command)
      end
    end
	end

	class CommentProjectHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Project, command.id) do |project|
        project.comment(command)
      end
    end
	end

	class Configuration
		def call(cqrs)
			register_commands(cqrs)
		end

private

		def register_commands(cqrs)
			cqrs.register_command(Commands::CreateProject, CreateProjectHandler.new(cqrs.event_store), Events::ProjectCreated)
			cqrs.register_command(Commands::ChangeProjectState, ChangeProjectStateHandler.new(cqrs.event_store), Events::ProjectStateChanged)
			cqrs.register_command(Commands::CommentProject, CommentProjectHandler.new(cqrs.event_store), Events::ProjectCommented)
		end
	end
end
