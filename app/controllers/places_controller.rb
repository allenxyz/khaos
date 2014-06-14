class PlacesController < ApplicationController
	def filter
		
	end

	def reload
	end

	def randomize
	end

	def index
		puts params
		puts session[:user_id]
		@user = User.find_by(:name => session[:user_id])
	end
end
