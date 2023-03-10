module ProjectsHelper
	def timestamp_of_change(change)
		case change
		when Hash
			change[:created_at]
		when Comment
			change.created_at
		end
	end

	def type_of_change(change)
		case change
		when Hash
			"Change state"
		when Comment
			"Comment on project"
		end
	end

	def data_of_change(change)
		case change
		when Hash
			"From: #{change[:old_state]}"
		when Comment
			change.text
		end
	end
end
