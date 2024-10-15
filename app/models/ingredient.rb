class Ingredient < ApplicationRecord
  has_many :ingredient_reviews

  validates :name, :description, presence: true
end
