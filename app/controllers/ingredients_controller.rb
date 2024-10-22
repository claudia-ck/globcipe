class IngredientsController < ApplicationController
  def show
    @ingredient = Ingredient.find(params[:id])

    @substitutes = Substitute.where(ingredient_id: params[:id])

    @ingredient_review = IngredientReview.new

    # map
    @shops = @ingredient.shops
    # The `geocoded` scope filters only flats with coordinates
    @shopmarkers = @shops.map do |shop|
      {
        lat: shop.latitude,
        lng: shop.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { shop: shop })
      }
    end
  end
end
