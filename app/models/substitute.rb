class Substitute < ApplicationRecord
  belongs_to :ingredient

  validates :name, uniqueness: true
  validates :name, :ingredient_id, presence: true
end
