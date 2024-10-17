class RecipesController < ApplicationController
  def index
    search = params[:search]
    if search.present?
      area = search[:area]
      @recipes = Recipe.where(area: area)
    else
      @recipes = Recipe.all
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @favourite = Favourite.new
    # @ingredient = Ingredient.find(params[:ingredient_id])
  end
end
