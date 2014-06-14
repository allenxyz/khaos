class PlacesController < ApplicationController
	def button_no
		redirect_to '/index'
	end

	def button_yes
		redirect_to	"/index"
	end

	def button_random
		redirect_to "/index"
	end

	def index
		puts params
		puts session[:user_id]
		@user = User.find_by(:name => session[:user_id])
	end
end
