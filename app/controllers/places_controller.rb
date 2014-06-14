class PlacesController < ApplicationController
	def index
		puts params
		puts session[:user_id]
		@user = User.find_by(:name => session[:user_id])
	end
end
