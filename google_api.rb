require 'rest-client'
require 'json'

puts "Testing Google Search"

puts "loading..."

count = 0

data = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=-33.9166700,18.4166700&radius=50000&sensor=false&types=food")

while count <= 3

	puts '----------------------------------------------'

	parsed_data = JSON.parse(data)

	result = parsed_data['results']

	odd = 0

	while (odd < result.size) #spit out 20 recs each time
		name = result[odd]["name"]
		puts name
		odd = odd + 1
	end

	pagetoken = parsed_data['next_page_token']

	data = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAEWhLSygrd0gCgpyC0DloRAcvWgB9Ws_w&location=-33.9166700,18.4166700&radius=50000&sensor=false&types=food&pagetoken=#{pagetoken}")
	
	count = count + 1
end
