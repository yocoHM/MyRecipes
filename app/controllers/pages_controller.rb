class PagesController < ApplicationController

	def home
		#se dirige a recipes_path si es que hay un usario loggeado
		redirect_to recipes_path if logged_in?
	end 

end