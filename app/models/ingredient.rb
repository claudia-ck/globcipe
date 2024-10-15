class Ingredient < ApplicationRecord
  has_many :ingredient_reviews
  has_many :recipes, through: :ingredient_reviews

  validates :name, presence: true
end
