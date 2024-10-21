class AddEmbeddedYtColumnToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :embedded_youtube_url, :string
  end
end
