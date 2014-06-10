class Rec < ActiveRecord::Base
	belongs_to :user
	has_one :data
end
