class AddYtColumnToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :youtube_url, :string
  end
end
