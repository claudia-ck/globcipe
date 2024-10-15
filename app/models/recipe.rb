class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_one :favourite

  validates :name, :instruction, :category, :area, presence: true
  validates :name, uniqueness: true
end
