class CreateIngredientShops < ActiveRecord::Migration[7.2]
  def change
    create_table :ingredient_shops do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
