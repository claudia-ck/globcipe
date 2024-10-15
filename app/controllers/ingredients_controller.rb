class IngredientsController < ApplicationController
  def show
    @ingredient = Ingredient.find(params[:id])

    @ingredient_review = IngredientReview.new
  end
end
