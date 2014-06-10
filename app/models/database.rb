class Database < ActiveRecord::Base
	belongs_to :rec
	has_and_belongs_to_many :tag
	
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
end
