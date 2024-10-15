class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
#  :remakrs is optional field
end
