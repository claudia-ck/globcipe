class IngredientReviewsController < ApplicationController
  def create
    @ingredient_review = Ingredient_review.new(ingredient_review_params)
    @ingredient = Ingredient.find(params[:recipe_id])
    @ingredient_review.ingredient = @ingredient
    @ngredient_review.user = current_user

    if @ingredient_review.save
      redirect_to ingredient_path(@ingredient)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient_review = Ingredient_review.find(params[:id])
    @ingredient_review.destroy
    redirect_to ingredient_path(@ingredient), status: :see_other
  end

  def edit
    @ingredient_review = Ingredient_review.find(params[:id])
  end

  def update
    @ingredient_review = Ingredient_review.find(params[:id])
    @ingredient_review.update(ingredient_review_params)
    redirect_to ingredient_path(@ingredient)
  end

  private
  def ingredient_review_params
    params.require(:ingredient_review).permit(:comment)
  end
end
