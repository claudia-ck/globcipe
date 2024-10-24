class RecipesController < ApplicationController
  def index
    area = params[:search].nil? ? nil : params[:search][:area].capitalize
    category = params[:search].nil? ? nil : params[:search][:category].capitalize

    if area.nil? && category.nil?
      @recipes = category_driven_recipes
    elsif area.present? && category.present?
      @recipes = Recipe.where(area: area, category: category)
    elsif area.present?
      @recipes = Recipe.where(area: area)
    elsif category.present?
      @recipes = Recipe.where(category: category)
    else
      @recipes = category_driven_recipes
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @favourite = Favourite.new
    # @ingredient = Ingredient.find(params[:ingredient_id])
  end

  private

  def category_driven_recipes
    categories = ['Beef', 'Breakfast', 'Chicken', 'Dessert', 'Goat', 'Lamb', 'Miscellaneous', 'Pasta', 'Pork',
                  'Seafood', 'Side', 'Starter', 'Vegan', 'Vegetarian']
    recipes_truncated = []
    categories.each do |category|
      recipes_category_specific = Recipe.where(category: category)
      recipe_category_specific_random = recipes_category_specific[0]
      recipes_truncated << recipe_category_specific_random
    end
    recipes_truncated << Recipe.last
    recipes_truncated << Recipe.find_by(id: Recipe.last.id - 1)
    return recipes_truncated
  end

  def search_params
    return false if params[:search].nil?

    params.require(:search).permit(:area, :category)
  end
end
