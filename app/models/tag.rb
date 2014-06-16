class Tag < ActiveRecord::Base
	has_one :affinity
	has_and_belongs_to_many :places
	has_and_belongs_to_many :recs
	belongs_to :user

	

	validates_presence_of :tag
	
end
