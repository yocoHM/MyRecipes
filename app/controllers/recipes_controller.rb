class RecipesController < ApplicationController

	#el orden de los before_action es importante
	before_action :set_recipe, only: [:edit, :update, :show, :like]
	before_action :require_user, except: [:show, :index]
	before_action :require_same_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy

	def index
		@recipes = Recipe.all.sort_by{|likes| likes.thumbs_up_total}.reverse
	end

	def show
		#se hace el befor_action de set_recipe
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.chef = current_user

		if @recipe.save
			flash[:success] = "Your recipe was created successfully!"
			redirect_to recipes_path 	
		else 
			render :new
		end

	end

	def edit
		#se hace el befor_action de set_recipe
	end

	def update
		#se hace el befor_action de set_recipe
		if @recipe.update(recipe_params)
			flash[:success] = "Your recipe was updated successfully!"
			redirect_to recipe_path(@recipe)
		else
			render :edit
		end
	end

	def like
		#se hace el befor_action de set_recipe
		like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
		if like.valid?
			flash[:success] = "Your selection was successful"
			redirect_to :back
		else
			flash[:danger] = "You can only like/dislike a recipe once"
			redirect_to :back
		end
	end

	def destroy
		Recipe.find(params[:id]).destroy
		flash[:success] = "Recipe deleted"
		redirect_to recipes_path
	end

	#actions privadas
	private

			def recipe_params
				params.require(:recipe).permit(:name, :summary, :description)
			end

			def set_recipe
				@recipe = Recipe.find(params[:id])
			end

			def require_same_user
				if current_user != @recipe.chef and !current_user.admin?
					flash[:danger] = "You can only edit your own recipes"
					redirect_to recipes_path
				end
			end

			def admin_user
				redirect_to recipes_path unless current_user.admin?
			end

end