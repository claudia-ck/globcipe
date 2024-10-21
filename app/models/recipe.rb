class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favourites, dependent: :destroy

  validates :name, :instruction, :category, :area, presence: true
  validates :name, uniqueness: true

  geocoded_by :area
  after_validation :geocode, if: :will_save_change_to_area?
end
