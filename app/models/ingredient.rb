class Ingredient < ApplicationRecord
  has_many :ingredient_reviews

  validates :name, presence: true
end
