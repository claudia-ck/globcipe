class CreateSubstitutes < ActiveRecord::Migration[7.2]
  def change
    create_table :substitutes do |t|
      t.string :name
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
