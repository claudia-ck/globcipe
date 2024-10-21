class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def favourites
    @favourites = current_user.favourites

    @recipes = @favourites.map do |favourite|
      favourite.recipe
    end

    # @markers = @recipes.geocoded.map do |recipe|

    @markers = @recipes.map do |recipe|
      {
        lat: recipe.latitude,
        lng: recipe.longitude
      }
    end
  end

end
