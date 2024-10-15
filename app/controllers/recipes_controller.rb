class RecipesController < ApplicationController
  def index
    @recipe = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @favourite = Favourite.new
    # @ingredient = Ingredient.find(params[:ingredient_id])
  end
end
