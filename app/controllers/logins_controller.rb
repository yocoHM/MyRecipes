#este controller es para manejar los logins. Se usan sesiones que son controladas
#con cookies en el buscador.
class LoginsController < ApplicationController

	def new

	end

	def create
		chef = Chef.find_by(email: params[:email])

		if chef && chef.authenticate(params[:password])
			session[:chef_id] = chef.id
			flash[:success] = "Entraste a tu cuenta"
			redirect_to recipes_path
		else
			flash.now[:danger] = "Tu email o tu contraseña son incorrectos"
			render 'new'
		end
	end

	def destroy
		session[:chef_id] = nil
		flash[:success] = "Saliste de tu cuenta"
		redirect_to root_path
	end

end