class PlacesController < ApplicationController

	#this will need to be changed manually


	def button_no
		@user = User.find_by(:name => session[:user_id])
		# decrement all the afinities

		@user.recs.last.tags.each do |tag|
			a = tag.affinity
			a.aff -= 1 if a.aff > 1
			a.save
		end
		redirect_to '/find'
	end

	def button_yes
		@user = User.find_by(:name => session[:user_id])
		#increment all the affinities
		@user.recs.last.tags.each do |tag|
			a = tag.affinity
			a.aff += 1 
			a.save
		end
		redirect_to	"/find"
	end


	def button_random
		redirect_to "/find"
	end

	def reset
		@user = User.find_by(:name => session[:user_id])

		@user.recs.each {|rec| rec.destroy }

		@user.tags.each do |tag|	
			a = tag.affinity
			a.aff = 5
			a.save
		end
		redirect_to "/find"
	end



	def find
		@user = User.find_by(:name => session[:user_id])


		if !(@place = Place.find_rec_place(session))
			flash[:error] = "Ran out of good locations - We'll try to find more places! In the meantime, Please try again"
			@place = Place.find_by(:loc => "Can't find....")
		else 		
			rec = to_rec(@place)
			rec.place = @place
			#link it to approriate tag
			@place.tags.each do |tag|
				t = @user.tags.find_by(:tag => tag.tag)
				next if t == nil
				rec.tags << t
			end


			@user.recs << rec
		end
		redirect_to "/index"
	end
	
	def index
		@user = User.find_by(:name => session[:user_id])
		@place = @user.recs.last.place
	end

	def feed
		tags = %w[bar bakery cafe food restaurant money_0 money_1 money_2 money_3 money_4]
		change_tags(tags, session[:user_id])
		redirect_to '/find'
	end

	def drink
		tags = %w[bar bakery cafe food liquor_store restaurant money_0 money_1 money_2 money_3 money_4]
		change_tags(tags, session[:user_id])
		redirect_to '/find'
	end

	def shop
		tags = %w[art_gallery bicycle_store book_store clothing_store department_store jewelry_store liquor_store shopping_mall money_0 money_1 money_2 money_3 money_4]
		change_tags(tags, session[:user_id])
		redirect_to '/find'
	end


	def see
		tags = %w[amusement_park aquarium beauty_salon bicycle_store book_store bowling_alley campground casi1 cemetery church city_hall courthouse establishment gym hindu_temple library mosque movie_theater museum night_club park place_of_worship rv_park shopping_mall school spa stadium synagogue university zoo money_0 money_1 money_2 money_3 money_4]
		change_tags(tags, session[:user_id])
		redirect_to '/find'
	end

	def all
		tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo]
		change_tags(tags, session[:user_id])
		redirect_to '/find'
	end

	def test
		@user = User.find_by(:name => session[:user_id])
		@place = @user.recs.last.place

	end

	private 

		def to_rec(place)
			return Rec.create(:loc => place.loc, :place_id => place.id)
		end


		def print_affinities
			@user.tags.each do |tag|
				puts "#{tag.tag}: #{tag.affinity.aff}"
			end
		end

		def change_tags(tags, user_id)
			all_tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum night_club park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo money_0 money_1 money_2 money_3 money_4]			
			user = User.find_by(:name => user_id)



			############################################################################################################
			if user.tags.length >= 46 ############################################################################################################Stupid way for now - don't wanna figure it out....
			####################################################################################################################################################################################				
				user.tags.each do |tag| 
					if !(tags.include?(tag.tag))
						tag.delete
					end
				end

			else
				#delete all
				user.tags.each { |tag| tag.delete } 
				#add all them 
				tags.each do |tag|
					a = Tag.create(:tag => "#{tag}", :user_id => user.id)
					a.affinity = Affinity.create(:aff => 5)
				end
			end
		end


end
