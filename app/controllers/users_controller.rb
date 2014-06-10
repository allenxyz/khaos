class UsersController < ApplicationController
	def new
		@input = User.new
	end

	def create
		curloc = params[:user][:curloc]	


		if !(@user = User.find_by(:name => session[:user_id]))
			session[:user_id] = (0...8).map { (65 + rand(26)).chr }.join   #create a random length 8 string
			#find log and lat
			:geocode
			#create user
			@user = User.create(:name => session[:user_id], :curloc => curloc)
		else
			if curloc != @user.curloc
				@user.curloc = curloc
				:geocode
			end
			#############################     DO THIS WHEN YOU KNOW HOW THE THING WORKS!!!
		end

		puts @user.id
		redirect_to "/users/index/#{@user.id}"

	end


	def index
		@user = User.find(params[:id])

	end



	private
		def user_params
			params.require(:User).permit(:name, :curloc, :long, :lat)

		end



end
