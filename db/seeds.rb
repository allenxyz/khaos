# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' } { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel' city: cities.first)
#this is gaby's
# api_key = "AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w"
#this is allen's
# api_key = "AIzaSyBivUBNUOpt97vaaM18ZedO1h6QPmZ4rDY"
# this is binyan's
api_key = "AIzaSyAlO925Y6VgUheWH9RrYKDiTjSpIYKsq6Y"

require 'open-uri'




############### CHANGE THIS ----- IMPORNTANT
# mode = 1 => create everything from scratch - using code v1
# mode = 2 => create everything from scratch - using code v2
# mode = 3 => using code v3
# mode = 4 => continuously add places
mode = 1




def parse(url)
	safe_url = URI.encode(url)
	JSON.parse(RestClient.get(safe_url))
end



# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------
# ============================ Version 1. =======================================
# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------



# # ===========================================================================
# # ===========================================================================
# # ===========================================================================
# # ============================create tags====================================
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================

if mode == 1



	tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]

	#create all master tags (won't be related to any user_id)
	tags.each do |tag|
		Tag.create(:tag => "#{tag}")
	end

	Tag.create(:tag => "money_0")
	Tag.create(:tag => "money_1")
	Tag.create(:tag => "money_2")
	Tag.create(:tag => "money_3")
	Tag.create(:tag => "money_4") 

	# meal_delivery (food!)
	# meal_takeaway (food!)




	# # ===========================================================================
	# # ===========================================================================
	# # ===========================================================================
	# # ========================extract info from API==============================
	# # ===========================================================================
	# # ===========================================================================
	# # ===========================================================================



	########################### GOOGLE PLACES (60 from each tag + price)
	# pagetoken = ""


	########################## GOOGLE PLACES (60 from each tag + price)

	puts tags
			
	double_check_places = []

	pagetoken = ""

	money = 4
	test = false

	if (test)
		money = 3
		tags = ["food", "bar"]
	end

	while (money >= 0)
		minprice = "&minprice=#{money}"
		maxprice = "&maxprice=#{money}"

		tags.each do |tag|
			puts "#{tag}, #{money}"
			page = 0

			while true
				puts "-----------------------------\nPage#{page}"
				puts "Extracting!"
				url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=-33.922015,18.419624&radius=50000&sensor=false#{minprice}#{maxprice}&types=#{tag}#{pagetoken}"
				puts url
				data = RestClient.get(url)
				parsed_data = JSON.parse(data)

				result = parsed_data['results']

				ctr = 0
				while (ctr < result.size) #spit out 20 recs each time
					name = result[ctr]['name']
					types = result[ctr]['types']

					long = result[ctr]['geometry']['location']['lng']
					lat = result[ctr]['geometry']['location']['lat']
					address = result[ctr]['vicinity']
					puts "#{name} @ #{address}"

					#getting Google details API

					ref = result[ctr]['reference']

					puts "https://maps.googleapis.com/maps/api/place/details/json?key=#{api_key}&reference=#{ref}&sensor=false"
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

				puts parsed_data['next_page_token']

				break if !parsed_data['next_page_token']

				page += 1
				pagetoken = "&pagetoken=" + parsed_data['next_page_token']

			end
			page = 0
			pagetoken = ""
			
		end
		money -= 1

	end

	double_check_places.each {|place| puts place}




	# # pagetoken = ""
	# test = false


	#create empty place
	Place.create(:loc => "Can't find....", :address => "", :full_address => "", :img => "", :url => ""	)


end





# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------
# ============================ Version 2. =======================================
# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------
######### this is only for first time creating
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================
# # ============================create tags====================================
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================

if mode == 2


	list_tag =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]

	#create all master tags (won't be related to any user_id)
	list_tag.each do |tag|
		Tag.create(:tag => "#{tag}")
	end

	Tag.create(:tag => "money_0")
	Tag.create(:tag => "money_1")
	Tag.create(:tag => "money_2")
	Tag.create(:tag => "money_3")
	Tag.create(:tag => "money_4") 

	# meal_delivery (food!)
	# meal_takeaway (food!)




	# # ===========================================================================
	# # ===========================================================================
	# # ===========================================================================
	# # ========================extract info from API==============================
	# # ===========================================================================
	# # ===========================================================================
	# # ===========================================================================



	require 'open-uri'
	require 'json'


	########################### GOOGLE PLACES (60 from each tag + price)
	# pagetoken = ""


	########################## GOOGLE PLACES (60 from each tag + price)

	double_check_places = []

	pagetoken = ""

	long = 18.419624
	lat = -33.922015
	radius = 20

	tags = ""
	list_tag.each do |tag|
		tags += "#{tag}|"
	end
	tags = tags[0..-2]
	page = 0
	puts tags



	while true
		#free stuff
		while true
			puts "-----------------------------\nPage#{page}"
			puts "Extracting!"
			url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&sensor=false#{pagetoken}&minprice=0&maxprice=0"
			safe_url = URI.escape(url)
			puts safe_url
			data = RestClient.get(safe_url)
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
				url_event = []

				dummy = false

				if (new_result['events'])
					no_event = 0

					while (no_event < new_result['events'].size)
						google_id << new_result['events'][no_event]['event_id']
						start_time << new_result['events'][no_event]['start_time']
						summary << new_result['events'][no_event]['summary']
						url_event << new_result['events'][no_event]['url']

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
							e = Event.create(:google_id => google_id[counter], :start_time => start_time[counter], :summary => summary[counter], :url => url_event[counter])
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

				break if double_check_places.size >= 5

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
			url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{api_key}&location=#{lat},#{long}&rankby=distance&types=#{tags}&sensor=false#{pagetoken}&minprice=1&maxprice=4"
			parsed = parse(url)
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

				url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{api_key}&reference=#{ref}&sensor=false"
				new_parsed_detail = parse(url)
				new_result = new_parsed_detail['result']

				google_id = start_time = summary = url_event = []
				dummy = false

				if (new_result['events'])
					no_event = 0
					while (no_event < new_result['events'].size)
						google_id << new_result['events'][no_event]['event_id']
						start_time << new_result['events'][no_event]['start_time']
						summary << new_result['events'][no_event]['summary']
						url_event << new_result['events'][no_event]['url']
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
					a = Place.create(:loc => name, :longitude => long, :latitude => lat, :rating => rating, :address => address, :full_address => full_address, :img => img, :url => website)

					if (dummy)
						counter = 0
						while (counter < google_id.size)
							e = Event.create(:google_id => google_id[counter], :start_time => start_time[counter], :summary => summary[counter], :url => url_event[counter])
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
				break if double_check_places.size >= 10
				ctr += 1
			end

			puts parsed['next_page_token']

			break if double_check_places.size >= 10

			break if !parsed['next_page_token']

			page += 1
			pagetoken = "&pagetoken=" + parsed['next_page_token']

		end


		#add some randomness

		lng_offset = rand() / 10
		lng_offset = lng_offset * -1 if rand(2) 
		lat_offset = rand() / 10 
		lat_offset = lat_offset * -1 if rand(2)
		long = result.last['geometry']['location']['lng'] + lng_offset
		lat = result.last['geometry']['location']['lat'] + lat_offset


		puts "#{long}, #{lat}"
		double_check_places = []






	end
end





















if mode == 3
	# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------
# ============================ Version 3. =======================================
# -------------------------------------------------------------------------------
# ===============================================================================
# -------------------------------------------------------------------------------



# # ===========================================================================
# # ===========================================================================
# # ===========================================================================
# # ============================create tags====================================
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================


	tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]

	#create all master tags (won't be related to any user_id)
	tags.each do |tag|
		Tag.create(:tag => "#{tag}")
	end

	Tag.create(:tag => "money_0")
	Tag.create(:tag => "money_1")
	Tag.create(:tag => "money_2")
	Tag.create(:tag => "money_3")
	Tag.create(:tag => "money_4") 

	# meal_delivery (food!)
	# meal_takeaway (food!)




	puts tags
			
	double_check_places = []

	pagetoken = ""

	test = false
	count = 2


	long = 18.419624
	lat = -33.922015
	radius = 500
	result = []

	while true

		
		while (count > 0)
			if count == 2
				minprice = "&minprice=0"
				maxprice = "&maxprice=2"
			elsif count == 1
				minprice = "&minprice=3"
				maxprice = "&maxprice=4"
			end		

			tags.each do |tag|
				puts "#{tag}, count: #{count}"
				page = 0

				while true
					puts "-----------------------------\nPage#{page}"
					puts "Extracting!"
					puts "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=#{lat},#{long}&radius=#{radius}&sensor=false#{minprice}#{maxprice}&types=#{tag}#{pagetoken}"
					data = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=#{lat},#{long}&radius=#{radius}&sensor=false#{minprice}#{maxprice}&types=#{tag}#{pagetoken}")
					parsed_data = JSON.parse(data)

					result = parsed_data['results']


					ctr = 0
					while (ctr < result.size) #spit out 20 recs each time
						name = result[ctr]['name']
						types = result[ctr]['types']
						price = result[ctr]['price_level']
						long = result[ctr]['geometry']['location']['lng']
						lat = result[ctr]['geometry']['location']['lat']
						address = result[ctr]['vicinity']
						puts "#{name} @ #{address}"

						#getting Google details API

						ref = result[ctr]['reference']

						detail = RestClient.get("https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&reference=#{ref}&sensor=false")
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
								end
							end

							a.tags << Tag.find_by(:tag => "money_#{price}")

						else
							#double check the info!
							puts "Existence found. Adding to double_check_places..."
							double_check_places << found

						end


						ctr += 1
					end

					puts parsed_data['next_page_token']

					break if !parsed_data['next_page_token']

					page += 1
					pagetoken = "&pagetoken=" + parsed_data['next_page_token']

				end
				page = 0
				pagetoken = ""
				
			end
			count -= 1

		end





		# # pagetoken = ""
		# test = false

		count = 2
		long_offset = rand() 
		long_offset *= -1 if rand(2)
		lat_offset = rand() 
		lat_offset *= -1 if rand(2)


		puts result
		long = long + long_offset
		lat = lat + lat_offset
		
		

	end




#create empty place

double_check_places.each {|place| puts place.loc}
Place.create(:loc => "Can't find....", :address => "", :full_address => "", :img => "", :url => ""	)


end







# Continously add place
if mode == 4





















end
