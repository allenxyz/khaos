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
			# ill use a session first ----- deleting it is easy 


			#create random length 8 string - until you find one that's unused
			while (@user = User.find_by(:name => session[:user_id]))
				session[:user_id] = (0...8).map { (65 + rand(26)).chr }.join  
			end

			@user = User.create(:name => session[:user_id], :curloc => curloc)
			@user.geocode
			@user.save
		else
			if curloc != @user.curloc
				@user.curloc = curloc
				@user.geocode
				@user.recs
				@user.save
			end
			#############################     DO THIS WHEN YOU KNOW HOW THE THING WORKS!!!
		end

		redirect_to "/places"

	end





	private
		def user_params
			params.require(:User).permit(:name, :curloc, :long, :lat)

		end



end
