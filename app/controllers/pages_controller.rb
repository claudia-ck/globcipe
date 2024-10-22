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
        lng: recipe.longitude,
        info_window: render_to_string(partial: "popup", locals: {recipe: recipe}),
        image_url: helpers.asset_url("glocipe-logo.png")
      }
    end
  end


end
