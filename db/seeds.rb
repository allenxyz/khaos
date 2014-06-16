# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' } { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel' city: cities.first)


# # ===========================================================================
# # ===========================================================================
# # ===========================================================================
# # ============================create tags====================================
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================


# tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]

# #create all master tags (won't be related to any user_id)
# tags.each do |tag|
# 	Tag.create(:tag => "#{tag}")
# end

# Tag.create(:tag => "money_0")
# Tag.create(:tag => "money_1")
# Tag.create(:tag => "money_2")
# Tag.create(:tag => "money_3")
# Tag.create(:tag => "money_4") 

# # meal_delivery (food!)
# # meal_takeaway (food!)




# # ===========================================================================
# # ===========================================================================
# # ===========================================================================
# # ========================extract info from API==============================
# # ===========================================================================
# # ===========================================================================
# # ===========================================================================

# ########################### GOOGLE DETAILS (THE FOLLOWING INFO FOR EACH TAG)
# #address_components (long_name)
# #events[] (all)
# #formatted_address
# #icon
# #price_level -- for update
# #rating
# #website

# ########################### GOOGLE PLACES (60 from each tag + price)
# # pagetoken = ""
# test = false

# tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]

# ########################## GOOGLE PLACES (60 from each tag + price)

# puts tags
		
# double_check_places = []

# pagetoken = ""


# money = 4

# money = 4
# test = false

# if (test)
# 	money = 3
# 	tags = ["food", "bar"]
# end

# while (money >= 0)
# 	minprice = "&minprice=#{money}"
# 	maxprice = "&maxprice=#{money}"

# 	tags.each do |tag|
# 		puts "#{tag}, #{money}"
# 		page = 0

# 		while true
# 			puts "-----------------------------\nPage#{page}"
# 			puts "Extracting!"
# 			data = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=-33.9166700,18.4166700&radius=50000&sensor=false#{minprice}#{maxprice}&types=#{tag}#{pagetoken}")
# 			parsed_data = JSON.parse(data)

# 			result = parsed_data['results']


# 			ctr = 0
# 			while (ctr < result.size) #spit out 20 recs each time
# 				name = result[ctr]['name']
# 				types = result[ctr]['types']
# 				ratings = result[ctr]['ratings']

# 				puts ratings

# 				long = result[ctr]['geometry']['location']['lng']
# 				lat = result[ctr]['geometry']['location']['lat']
# 				address = result[ctr]['vicinity']
# 				puts "#{name} @ #{address}"


# 				#put into databse
# 				if (found = Place.where(:address => address, :loc => name))
# 					a = Place.create(:loc => name, :longitude => long, :latitude => lat, :rating => ratings, :address => address)

# 				#put into databse
# 				if (found = Place.where(:address => address, :loc => name))
# 					a = Place.create(:loc => name, :longitude => long, :latitude => lat, :rating => ratings, :address => address)


# 					types.each do |type|
# 						if (Tag.find_by(:tag => type))
# 							if (type == "meal_delivery") || (type == "meal_takeaway")
# 								type = "food"
# 							end


# 							find_tag = Tag.find_by(:tag => type)
# 							print "#{find_tag.tag }"
# 							a.tags << find_tag
# 						end

# 					end

# 					puts "money_#{money}"
# 					a.tags << Tag.find_by(:tag => "money_#{money}")

# 				else
# 					#double check the info!
# 					puts "Existence found. Adding to double_check_places..."
# 					double_check_places << found
# =======
# 					types.each do |type|
# 						if (Tag.find_by(:tag => type))
# 							if (type == "meal_delivery") || (type == "meal_takeaway")
# 								type = "food"
# 							end


# 							find_tag = Tag.find_by(:tag => type)
# 							print "#{find_tag.tag }"
# 							a.tags << find_tag
# 						end

# 					end

# 					puts "money_#{money}"
# 					a.tags << Tag.find_by(:tag => "money_#{money}")

# 				else
# 					#double check the info!
# 					puts "Existence found. Adding to double_check_places..."
# 					double_check_places << found

# 				end

# >>>>>>> 1c65ff641a2cdc5a084999a9a6cea6fe416376d4

# 				end


# 				ctr += 1
# 			end

# 			puts parsed_data['next_page_token']

# 			break if !parsed_data['next_page_token']

# 			page += 1
# 			pagetoken = "&pagetoken=" + parsed_data['next_page_token']

# 		end
# 		page = 0
# 		pagetoken = ""
		
# 	end
# 	money -= 1


# end

# puts double_check_places

# end

# puts double_check_places


# # # pagetoken = ""
# # test = false


# #create empty place
# Place.create(:loc => "Can't find....", :address => "", :full_address => "", :img => "", :url => ""	)
