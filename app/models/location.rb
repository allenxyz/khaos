require "geocoder"

class Location

	

geocoded_by :address
after_validation :geocode, :if => :address_changed?
end