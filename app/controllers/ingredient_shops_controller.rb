class IngredientShopsController < ApplicationController


  def create
    @ingredient = Ingredient.find(params[:ingredient_id])
    @ingredient_shop = IngredientShop.new(ingredient_shop_params)

    if @ingredient_shop.save
      redirect_to ingredient_path(@ingredient), notice: 'Shop was successfully added.'
    else
      render :new # or the appropriate view
    end
  end

  private

  def ingredient_shop_params
    params.require(:ingredient_shop).permit(:shop_id, :user_id)
  end
end
