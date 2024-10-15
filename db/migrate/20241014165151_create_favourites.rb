class CreateFavourites < ActiveRecord::Migration[7.2]
  def change
    create_table :favourites do |t|
      t.string :remarks
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
