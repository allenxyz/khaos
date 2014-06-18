class UsersController < ApplicationController
	def new
		@input = User.new
	end

	def create
		curloc = params[:user][:curloc]	
		if !(@user = User.find_by(:name => session[:user_id]))

			

			#should i use a session?
			# => don't want to save - i'm going to restart before the start of each anyways
			# => => need a way to keep track of :user_id when i move to places controller
			# => => Ill need a model to know User.long/lat anyways
			# 
			#  use a session first ----- deleting it is easy 

			# => tag not set up to handle many affinities => only ever one user
			

			#create random length 8 string - until you find one that's unused
			while (@user = User.find_by(:name => session[:user_id]))
				session[:user_id] = (0...8).map { (65 + rand(26)).chr }.join  
			end

			puts session[:user_id]

			@user = User.create(:name => session[:user_id], :curloc => curloc)
			
			#create all the tags that are related to the user
			tags =  %w[amusement_park aquarium art_gallery bakery bar beauty_salon bicycle_store book_store bowling_alley cafe campground casino cemetery church city_hall clothing_store courthouse department_store establishment food gym hindu_temple jewelry_store library liquor_store meal_delivery meal_takeaway mosque movie_theater museum park place_of_worship restaurant rv_park shopping_mall school spa stadium synagogue university zoo money_0 money_1 money_2 money_3 money_4]
			tags.each do |tag|
				a = Tag.create(:tag => "#{tag}", :user_id => @user.id)
				a.affinity = Affinity.create(:aff => 5)
			end

			puts "MAKING a new user!!!"
			@user.geocode
			@user.save
		else
			puts "NOT making a new user"
			if curloc != @user.curloc
				@user.curloc = curloc
				@user.geocode
				@user.save
			end
			#############################     DO THIS WHEN YOU KNOW HOW THE THING WORKS!!!
		end

		redirect_to "/index"

	end


	def howto
	end

	def about
	end
	


	private
		def user_params
			params.require(:User).permit(:name, :curloc, :long, :lat)

		end



end
