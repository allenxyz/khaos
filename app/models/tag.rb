class Tag < ActiveRecord::Base
	has_one :affinity
	belongs_to :rec
	has_and_belongs_to_many :database

	
end
