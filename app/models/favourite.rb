class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
#  :remakrs is optional field

  validates :user_id, uniqueness: { scope: :recipe_id, message: "you have already favourited this recipe" }
end
