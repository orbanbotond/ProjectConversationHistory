class Project < ApplicationRecord
	has_paper_trail
	has_many :comments

	def history
    history = versions.map do |version|
      {
        created_at: version.created_at,
        change: version.event,
        old_state: version.reify.state
      }
    end

    comments.each { |comment| history << comment }

    history.sort_by! do |element|
      case element
      when Hash
        element[:created_at]
      when Comment
        element.created_at
      end
    end
	end
end
