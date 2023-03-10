module Conversations
  class Project
    include AggregateRoot

    def initialize(id)
      @id = id
      @state = 'initialized'
    end

    def create(command)
      event = Events::ProjectCreated.new( data: { id: @id, title: command.title, initial_state: @state } )

      apply event      
    end

    def change_state(command)
      event = Events::ProjectStateChanged.new( data: { id: @id, old_state: @state, new_state: command.new_state } )

      apply event
    end

    def comment(command)
      event = Events::ProjectCommented.new( data: { id: @id, comment: command.comment } )

      apply event
    end

    attr_reader :id, :title, :state, :comments

  private
    def comments
      @comments ||= []
    end

    on Events::ProjectCreated do |event|
      @title = event.data[:title]
      @state = event.data[:initial_state]
    end

    on Events::ProjectCommented do |event|
      comments << event.data[:comment]
    end

    on Events::ProjectStateChanged do |event|
      @state = event.data[:new_state]
    end
  end
end
