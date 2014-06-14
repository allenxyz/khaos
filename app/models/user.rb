class User < ActiveRecord::Base
	has_many :recs
	geocoded_by :curloc

	#returns a location at random that's contained within places
	def random (places)
		return places[rand(places.length)]
	end

end
