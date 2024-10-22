class Shop < ApplicationRecord
  has_many :ingredient_shops
  has_many :ingredients, through: :ingredient_shops

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
