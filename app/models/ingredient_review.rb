class IngredientReview < ApplicationRecord
  belongs_to :ingredient
  belongs_to :user

  validates :comment, presence: true
end
