class CreateIngredientReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :ingredient_reviews do |t|
      t.string :comment
      t.references :ingredient, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
