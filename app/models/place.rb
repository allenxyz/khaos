class Place < ActiveRecord::Base
	belongs_to :rec
	has_and_belongs_to_many :tags
	
	geocoded_by :loc
	after_validation :geocode, :if => :loc_changed?
end

