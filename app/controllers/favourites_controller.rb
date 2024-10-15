class FavouritesController < ApplicationController
  def create
    @favourite = Favourite.new(favourite_params)
    @recipe = Recipe.find(params[:recipe_id])
    @favourite.recipe = @recipe
    @favourite.user = current_user

    if @favourite.save
      redirect_to  recipe_path(recipe)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def favourite_params
    params.require(:favourite).permit(:remarks)
  end
end
