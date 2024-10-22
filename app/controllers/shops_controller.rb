class ShopsController < ApplicationController
  def new
    @ingredient = Ingredient.find(params[:ingredient_id]) # Get the ingredient context
    @shop = Shop.new
    @shops = Shop.all # Fetch all shops for the dropdown list
    @ingredient_shop = IngredientShop.new

  end

  def create
    @ingredient = Ingredient.find(params[:ingredient_id])

    # Check if shop_id is present
    if params[:ingredient_shop][:shop_id].present?
      # Create the association between the ingredient and the existing shop
      @ingredient_shop = IngredientShop.new(ingredient_id: @ingredient.id, shop_id: params[:ingredient_shop][:shop_id], user_id: current_user.id)
    else
      # If shop_id is not present, create a new shop
      @shop = Shop.new(shop_params)
      if @shop.save
        # Create the association for the new shop
        @ingredient_shop = IngredientShop.new(ingredient_id: @ingredient.id, shop_id: @shop.id, user_id: current_user.id)
      end
    end

    if @ingredient_shop && @ingredient_shop.save
      redirect_to ingredient_path(@ingredient), notice: 'Shop was successfully added.'
    else
      # Handle errors
      flash.now[:alert] = @ingredient_shop.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :address)
  end

  def ingredient_params
    params.require(:ingredient).permit(:shop_id, :user_id)
  end
end
