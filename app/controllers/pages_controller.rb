class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def favourites
    @favourites = current_user.favourites
  end

end
