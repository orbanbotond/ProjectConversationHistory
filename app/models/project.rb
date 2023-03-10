class Project < ApplicationRecord
	has_paper_trail
	has_many :comments
end
