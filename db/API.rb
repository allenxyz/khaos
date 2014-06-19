double_check_places = []

pagetoken = ""

long = 18.419624
lat = -33.922015
radius = 20


tag = %w[food museum]
tags = ""
tag.each do |tag|
	tags += "#{tag}|"
end
tags = tags[0..-2]
tags = "food"
page = 0
puts tags



while true
	#free stuff
	while true
		puts "-----------------------------\nPage#{page}"
		puts "Extracting!"
		puts "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&sensor=false#{pagetoken}&minprice=0&maxprice=0"
		data = open("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&sensor=false#{pagetoken}&minprice=0&maxprice=0").read
		parsed = JSON.parse(data)

		result = parsed['results']

		ctr = 0
		while (ctr < result.size) #spit out 20 recs each time

			types = result[ctr]['types']
			address = result[ctr]['vicinity']
				
			name = result[ctr]['name']
			long = result[ctr]['geometry']['location']['lng']
			lat = result[ctr]['geometry']['location']['lat']
			puts "#{name}: (long, lat) = (#{long},#{lat})"
			ref = result[ctr]['reference']

			detail = RestClient.get("https://maps.googleapis.com/maps/api/place/details/json?key=#{api_key}&reference=#{ref}&sensor=false")
			new_parsed_detail = JSON.parse(detail)
			new_result = new_parsed_detail['result']

			google_id = []
			start_time = []
			summary = []
			url = []

			dummy = false

			if (new_result['events'])
				no_event = 0

				while (no_event < new_result['events'].size)
					google_id << new_result['events'][no_event]['event_id']
					start_time << new_result['events'][no_event]['start_time']
					summary << new_result['events'][no_event]['summary']
					url << new_result['events'][no_event]['url']

					no_event += 1
				end

				dummy = true
			end

			full_address = new_result['formatted_address']
			img = new_result['icon']
			website = new_result['website']
			rating = new_result['rating']
			money = 0

			#put into databse
			found = Place.where(:address => address, :loc => name)
			if (found.empty?)
				a = Place.create(:loc => name, :longitude => long, :latitude => lat, :rating => rating, :address => address, :full_address => full_address, :img => img, :url => website, :rating => rating)

				if (dummy)
					counter = 0
					while (counter < google_id.size)
						e = Event.create(:google_id => google_id[counter], :start_time => start_time[counter], :summary => summary[counter], :url => url[counter])
						a.events << e
						counter += 1
					end
				end

				types.each do |type|
					if (Tag.find_by(:tag => type))

						if (type == "meal_delivery") || (type == "meal_takeaway")
							type = "food"
						end

						find_tag = Tag.find_by(:tag => type)
						print "#{find_tag.tag }"
						a.tags << find_tag
					else
						next
					end					
				end

				a.tags << Tag.find_by(:tag => "money_#{money}")

			else
				#double check the info!
				puts "Existence found. Adding to double_check_places..."
				double_check_places << found

			end

			ctr += 1
		end

		puts parsed['next_page_token']


		break if double_check_places.size >= 5

		break if !parsed['next_page_token']

		page += 1
		pagetoken = "&pagetoken=" + parsed['next_page_token']

	end


	#exclude free stuff
	while true
		puts "-----------------------------\nPage#{page}"
		puts "Extracting!"
		puts "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&sensor=false#{pagetoken}&minprice=1&maxprice=4"

		data = open("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&(pagetoken)sensor=false&minprice=1&maxprice=4").read
		parsed = JSON.parse(data)

		result = parsed['results']

		ctr = 0
		while (ctr < result.size) #spit out 20 recs each time

			types = result[ctr]['types']
			address = result[ctr]['vicinity']
				
			name = result[ctr]['name']
			long = result[ctr]['geometry']['location']['lng']
			lat = result[ctr]['geometry']['location']['lat']
			puts "#{name}: (long, lat) = (#{long},#{lat})"
			ref = result[ctr]['reference']

			detail = RestClient.get("https://maps.googleapis.com/maps/api/place/details/json?key=#{api_key}&reference=#{ref}&sensor=false")
			new_parsed_detail = JSON.parse(detail)
			new_result = new_parsed_detail['result']

			google_id = []
			start_time = []
			summary = []
			url = []

			dummy = false

			if (new_result['events'])
				no_event = 0

				while (no_event < new_result['events'].size)
					google_id << new_result['events'][no_event]['event_id']
					start_time << new_result['events'][no_event]['start_time']
					summary << new_result['events'][no_event]['summary']
					url << new_result['events'][no_event]['url']

					no_event += 1
				end

				dummy = true
			end

			full_address = new_result['formatted_address']
			img = new_result['icon']
			website = new_result['website']
			rating = new_result['rating']
			money = result[ctr]['price_level']

			#put into databse
			found = Place.where(:full_address => full_address, :loc => name)
			if (found.empty?)
				a = Place.create(:loc => name, :longitude => long, :latitude => lat, :rating => rating, :address => address, :full_address => full_address, :img => img, :url => website, :rating => rating)

				if (dummy)
					counter = 0
					while (counter < google_id.size)
						e = Event.create(:google_id => google_id[counter], :start_time => start_time[counter], :summary => summary[counter], :url => url[counter])
						a.events << e
						counter += 1
					end
				end

				types.each do |type|
					if (Tag.find_by(:tag => type))

						if (type == "meal_delivery") || (type == "meal_takeaway")
							type = "food"
						end

						find_tag = Tag.find_by(:tag => type)
						print "#{find_tag.tag }"
						a.tags << find_tag
					else
						next
					end					
				end

				a.tags << Tag.find_by(:tag => "money_#{money}")

			else
				#double check the info!
				puts "Existence found. Adding to double_check_places..."
				double_check_places << found

			end

			ctr += 1
		end

		puts parsed['next_page_token']

		break if double_check_places.size >= 10

		break if !parsed['next_page_token']

		page += 1
		pagetoken = "&pagetoken=" + parsed['next_page_token']

	end





	long = new_result['geometry']['location']['lng']
	lat = new_result['geometry']['location']['lat']
	double_check_places = []






end