class Ingredient < ApplicationRecord
  has_many :ingredient_reviews
  has_many :recipes, through: :ingredient_reviews

  has_many :ingredient_shops
  has_many :shops, through: :ingredient_shops

  has_many :substitutes

  validates :name, presence: true
end
