class FavouritesController < ApplicationController
  def create
    @favourite = Favourite.new(favourite_params)
    @recipe = Recipe.find(params[:recipe_id])
    @favourite.recipe = @recipe
    @favourite.user = current_user

    if @favourite.save
      redirect_to recipe_path(@recipe), notice: 'Recipe was successfully favorited'
    else
      redirect_to recipe_path(@recipe), alert: 'You can only favorite this recipe once.'
    end
  end

  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy
    redirect_to favourites_path, status: :see_other, notice: 'Favorite was successfully removed.'
  end


  private
  def favourite_params
    params.require(:favourite).permit(:remarks)
  end
end
