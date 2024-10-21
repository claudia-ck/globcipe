class RecipesController < ApplicationController
  def index
    search = params[:search]
    if search.present?
      area = search[:area]
      category = search[:category]
      if area.present? && category.present?
        @recipes = Recipe.where(area: area, category: category)
      elsif area.present?
        @recipes = Recipe.where(area: area)
      elsif category.present?
        @recipes = Recipe.where(category: category)
      end
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
