class IngredientShop < ApplicationRecord
  belongs_to :ingredient
  belongs_to :shop
  belongs_to :user
end
