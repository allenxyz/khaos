# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' } { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel' city: cities.first)


# ===========================================================================
# ===========================================================================
# ===========================================================================
# ============================create tags====================================
# ===========================================================================
# ===========================================================================
# ===========================================================================


# Tag.create(:tag => "amusement_park")
# Tag.create(:tag => "aquarium")
# Tag.create(:tag => "art_gallery")
# Tag.create(:tag => "bakery")
# Tag.create(:tag => "bar")
# Tag.create(:tag => "beauty_salon")
# Tag.create(:tag => "bicycle_store")
# Tag.create(:tag => "book_store")
# Tag.create(:tag => "bowling_alley")
# Tag.create(:tag => "cafe")
# Tag.create(:tag => "campground")
# Tag.create(:tag => "casino")
# Tag.create(:tag => "cemetery")
# Tag.create(:tag => "church")
# Tag.create(:tag => "city_hall")
# Tag.create(:tag => "clothing_store")
# Tag.create(:tag => "courthouse")
# Tag.create(:tag => "department_store")
# Tag.create(:tag => "establishment")
# Tag.create(:tag => "food") 	
# Tag.create(:tag => "gym")
# Tag.create(:tag => "hindu_temple")
# Tag.create(:tag => "jewelry_store")
# Tag.create(:tag => "library")
# Tag.create(:tag => "liquor_store")
# Tag.create(:tag => "mosque")
# Tag.create(:tag => "movie_theater")
# Tag.create(:tag => "museum")
# Tag.create(:tag => "night_club")
# Tag.create(:tag => "park")
# Tag.create(:tag => "place_of_worship")
# Tag.create(:tag => "restaurant")
# Tag.create(:tag => "rv_park")
# Tag.create(:tag => "school")
# Tag.create(:tag => "shopping_mall")
# Tag.create(:tag => "spa")
# Tag.create(:tag => "stadium")
# Tag.create(:tag => "synagogue")
# Tag.create(:tag => "university")
# Tag.create(:tag => "zoo")

# Tag.create(:tag => "money_0")
# Tag.create(:tag => "money_1")
# Tag.create(:tag => "money_2")
# Tag.create(:tag => "money_3")
# Tag.create(:tag => "money_4") 

# # meal_delivery (food!)
# # meal_takeaway (food!)




# ===========================================================================
# ===========================================================================
# ===========================================================================
# ========================extract info from API==============================
# ===========================================================================
# ===========================================================================
# ===========================================================================


########################### GOOGLE PLACES (60 from each tag + price)
# # pagetoken = ""
# test = false

# tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]
# puts tags
		
# double_check_places = []

# pagetoken = ""

# money = 4

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


