class Place < ActiveRecord::Base
	belongs_to :rec
	has_and_belongs_to_many :tags
	
	geocoded_by :full_address
	after_validation :geocode, :if => :full_address_changed?

	has_many :events

	#places needs to be some kind of ARRAY
	def self.random(places)
		places[rand(places.length - 1)]
	end
	
	#method 1 - linear scale - simple affinity ranges (0+)
	def self.find_rec_place(session)
		user = User.find_by(:name => session[:user_id])


		if user.recs.empty?
			return Place.random(Place.all)
		end

		affinityTotal = 0
		numTags = 0
		user.tags.each do |tag|
			affinityTotal += tag.affinity.aff 
			numTags += 1
		end

		affinityAverage = affinityTotal/numTags
		tags = {}


		# -----------------------------------------------------------------------------------



		user.tags.each do |tag|
			prob = tag.affinity.aff/affinityTotal
			random = rand()  							#change to average+1s.d. when you can
			tags[tag.tag] = true if (random <= prob*numTags) 

		end


		# -----------------------------------------------------------------------------------



		possible_place = Place.find_contains(tags)
		been_to = user.recs.map {|rec| rec.place}
		puts "ASDF #{possible_place} \n\n\n user: #{user.name}"

		#remove those that you have been to before

		possible_place.each_index do |index|
			while been_to.include?(possible_place[index])
				possible_place.delete_at(index)
			end
		end


		return nil if possible_place.empty? 


		return possible_place[rand(possible_place.length - 1)]


	end


	#returns an array of places that contains one or more of tags
	#tags must be a hash
	def self.find_contains(tags)
		retval = []
		Place.all.each do |place|
			place.tags.each do |tag|
				if tag.tag == "money_0" || tag.tag == "money_1" || tag.tag == "money_2" || tag.tag == "money_3" || tag.tag == "money_4"
					next
				end

				if tags[tag.tag] 
					retval << place
					break
				end

			end
		end
		return retval
	end


end

