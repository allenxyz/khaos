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

		been_to.each {|been| puts been}
		puts session[:user_id]

		been_to_names = been_to.map do |place| 
			Place.only_name(place.loc)
		end


		#remove those that you have been to before

		possible_place.each_index do |index|
			puts possible_place[index].loc
			while been_to.include?(possible_place[index]) || been_to_names.include?(Place.only_name(possible_place[index].loc))
				possible_place.delete_at(index)
				break if !possible_place[index+1]
			end
		end


		return nil if possible_place.empty? 


		return possible_place[rand(possible_place.length - 1)]


	end


	def self.only_name(loc)
		if (cut = (loc.index('-')))
			retval = loc[0..cut-1]  
			return retval.strip
		end
		return loc
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




	def self.list_tags(place)
		retval = ""
		place.tags.each	 do |tag|	
			next if ((tag.tag == "money_0") || (tag.tag == "money_1") || (tag.tag == "money_2") || (tag.tag == "money_3") || (tag.tag == "money_4"))
			add = tag.tag[0].upcase + tag.tag[1..-1]
			retval += add + ", "
		end
		puts retval

		#change all _ to spaces
		retval.each_char {|char| char = " " if char == "_"}

		return retval[0..(retval.length-3)]
	end



	def self.find_price(place)
		dollar = 0
		place.tags.reverse.each do |tag|
			if (tag.tag == "money_0") || (tag.tag == "money_1") || (tag.tag == "money_2") || (tag.tag == "money_3") || (tag.tag == "money_4")
				dollar = tag.tag[tag.tag.length - 1].to_i
				break
			end
		end

		retval = ""
		(dollar + 1).times {retval += "$"}
		puts retval
		return retval
	end

	def self.find_url(url)
		return "" if url.empty?
		if url.length >= 27
			return url[0..27] + "..."
		end


	end


end

