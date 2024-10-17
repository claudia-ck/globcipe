class IngredientsController < ApplicationController
  def show
    @ingredient = Ingredient.find(params[:id])

    @substitutes = Substitute.where(ingredient_id: params[:id])

    @ingredient_review = IngredientReview.new
  end
end
