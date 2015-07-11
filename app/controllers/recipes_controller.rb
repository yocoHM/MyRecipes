class RecipesController < ApplicationController

	#el orden de los before_action es importante
	before_action :set_recipe, only: [:edit, :update, :show, :like]
	before_action :require_user, except: [:show, :index, :like]
	before_action :require_user_like, only: [:like]
	before_action :require_same_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy

	def index
		@recipes = Recipe.paginate(page: params[:page], per_page: 4)
	end

	def show
		#se hace el before_action de set_recipe
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.chef = current_user

		if @recipe.save
			flash[:success] = "¡Tu receta fue creada satisfactoriamente!"
			redirect_to recipes_path 	
		else 
			render :new
		end

	end

	def edit
		#se hace el before_action de set_recipe
	end

	def update
		#se hace el befor_action de set_recipe
		if @recipe.update(recipe_params)
			flash[:success] = "¡Tu receta fue actualizada satisfactoriamente!"
			redirect_to recipe_path(@recipe)
		else
			render :edit
		end
	end

	def like
		#se hace el befor_action de set_recipe
		like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
		if like.valid?
			flash[:success] = "Te ha gustado esa receta"
			redirect_to :back
		else
			flash[:danger] = "Solo puedes darle me gusta/no me gusta a una receta una sola vez"
			redirect_to :back
		end
	end

	def destroy
		Recipe.find(params[:id]).destroy
		flash[:success] = "Receta eliminada"
		redirect_to recipes_path
	end

	#actions privadas
	private

			def recipe_params
				params.require(:recipe).permit(:name, :summary, :description, style_ids: [], ingredient_ids: [])
			end

			def set_recipe
				@recipe = Recipe.find(params[:id])
			end

			def require_same_user
				if current_user != @recipe.chef and !current_user.admin?
					flash[:danger] = "Solo puedes editar tus propias recetas"
					redirect_to recipes_path
				end
			end

			def require_user_like
    			if !logged_in?
      				flash[:danger] = "Debes de ingresar con tu cuenta para hacer esa acción"
     			 	redirect_to :back
    			end
  		end

			def admin_user
				redirect_to recipes_path unless current_user.admin?
			end

end