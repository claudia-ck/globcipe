class ShopsController < ApplicationController
  def new
    @ingredient = Ingredient.find(params[:ingredient_id])
    # @ingredient_shop = IngredientShop.new

    @shop = Shop.new
    @shops = Shop.all # Fetch all shops for the dropdown list
  end

  def create
    @shop = Shop.new(shop_params)
    @ingredient = Ingredient.find(params[:ingredient_id])
    if @shop.save

      # Assuming you have a join model IngredientShop
      # IngredientShop.create(ingredient_id: params[:ingredient_id], shop_id: @shop.id)

      # Redirect back to the ingredient show page with a success message

      # redirect_to recipes_path, notice: 'Shop was successfully added.'
      redirect_to new_ingredient_ingredient_shop_path(@ingredient), notice: 'Shop was successfully added.'
    else
      # If save fails, render the new shop form again
      # @shops = Shop.all
      render :new
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end
