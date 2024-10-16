class IngredientReviewsController < ApplicationController

  def index
    @ingredient_review = IngredientReview.all
    @ingredient_review = IngredientReview.new
  end

  def create
    @ingredient_review = IngredientReview.new(ingredient_review_params)
    @ingredient = Ingredient.find(params[:ingredient_id])
    @ingredient_review.ingredient = @ingredient
    @ingredient_review.user = current_user

    if @ingredient_review.save
      redirect_to ingredient_path(@ingredient)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient_review = IngredientReview.find(params[:id])
    @ingredient_review.destroy
    redirect_to ingredient_ingredient_review_path(@ingredient_review), status: :see_other
  end

  def edit
    @ingredient_review = IngredientReview.find(params[:id])
  end

  def update
    @ingredient_review = IngredientReview.find(params[:id])
    @ingredient_review.update(ingredient_review_params)
    redirect_to ingredient_ingredient_review_path(@ingredient_review)
  end

  private
  def ingredient_review_params
    params.require(:ingredient_review).permit(:comment)
  end
end
