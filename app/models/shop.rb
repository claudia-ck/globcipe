class Shop < ApplicationRecord
  has_many :ingredient_shops
  has_many :ingredients, through: :ingredient_shops

  validates :name, :address, presence: true
  validates :name, uniqueness: { scope: :address, message: "The shop is in the Globcipe community." }

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
