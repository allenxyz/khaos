require 'rest-client'
require 'json'

test = true

tags =  %w["amusement_park" "aquarium" "art_gallery" "bakery" "bar" "beauty_salon" "bicycle_store" "book_store" "bowling_alley" "cafe" "campground" "casino" "cemetery" "church" "city_hall" "clothing_store" "courthouse" "department_store" "establishment" "food" "gym" "hindu_temple" "jewelry_store" "library" "liquor_store" "meal_delivery" "meal_takeaway" "mosque" "movie_theater" "museum" "park" "place_of_worship" "restaurant" "rv_park" "shopping_mall" "school" "spa" "stadium" "synagogue" "university" "zoo"]
puts tags.length
		
double_check_places = []

pagetoken = ""

moeny = 1

if (test)
	money = 4
	tags = ["food", "bar"]
end


while (money <= 4)
	money_min = "&minprice=#{money}"
	money_max = "&maxprice=#{money}"
	tags.each do |tag|
		puts tag
		while true
			puts "-----------------------------\nPage#{ctr}"
			puts "Extracting!"
			data = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=-33.9166700,18.4166700&radius=50000&sensor=false&#{money_min}&#{money_max}types=#{tag}#{pagetoken}")
			parsed_data = JSON.parse(data)

			result = parsed_data['results']

			ctr = 0

			while (ctr < result.size) #spit out 20 recs each time
				name = result[ctr]['name']
				types = result[ctr]['types']
				ratings = result[ctr]['ratings']
				long = result[ctr]['geometry']['location']['lng']
				lat = result[ctr]['geometry']['location']['lat']
				address = result[ctr]['vicinity']
				puts "#{name} @ #{address}"


				#put into databse
				if !(found = Place.where(:address => address, :loc => name))
					a = Place.create(:loc => name, :longitutde => long, :latitude => lat, :rating => ratings, :address => address)

					types.each do |type|

						find_tag = Tag.find_by(:tag => type)
						a.tags << find_tag
						print "#{find_tag.tag}"
					end

					a.tags << Tag.find_by(:tag => "money#{money}")

				else
					#double check the info!
					puts "Existence found. Adding to double_check_places..."
					double_check_places << found

				end




				ctr += 1
			end

			puts parsed_data['next_page_token']

			break if !parsed_data['next_page_token']


			pagetoken = "&pagetoken=" + parsed_data['next_page_token']
		end
		pagetoken = ""
		
	end
end






