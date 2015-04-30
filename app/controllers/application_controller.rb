class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #metodos creados aqui estan disponibles para otros controllers pero no para todas
  #las views.

  #para hacer disponibles los metodos para todas las views, se usa helper_method
  helper_method :current_user, :logged_in?

  #metodo para saber si el usuario loggeado  puede hacer una accion 
  def current_user
  	#se guarda al usuario actual que esta loggeado por cuestion de eficiencia
  	#para no accesar a la base de datos todo el tiempo
  	@current_user ||= Chef.find(session[:chef_id]) if session[:chef_id]
  end

  #metodo para saber si alguiern esta loggeado
  def logged_in?
  	#devuelve un booleano para saber si hay un usuario loggeado o no. 
  	#para eso sirven los dos signos de exclamacion !!
  	!!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to :back
    end
  end

end
