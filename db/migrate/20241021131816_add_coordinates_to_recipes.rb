class AddCoordinatesToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :latitude, :float
    add_column :recipes, :longitude, :float
  end
end
