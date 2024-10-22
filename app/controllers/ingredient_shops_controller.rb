class IngredientShopsController < ApplicationController
  def new
    @ingredient = Ingredient.find(params[:ingredient_id])
    @ingredient_shop = IngredientShop.new
    @shop = Shop.new
    @shops = Shop.all # Fetch all shops for the dropdown list
  end

  def create
    ingredient = Ingredient.find(params[:ingredient_id])
    shop = Shop.find(params["ingredient_shop"]["shop_id"])
    @ingredient_shop = IngredientShop.new
    @ingredient_shop.user = current_user
    @ingredient_shop.shop = shop
    @ingredient_shop.ingredient = ingredient

    if @ingredient_shop.save
      redirect_to ingredient_path(ingredient), notice: 'Shop was successfully added.'
    else
      render :new # or the appropriate view
    end
  end

  private

  def ingredient_shop_params
    params.require(:ingredient_shop).permit(:shop)
  end
end
