class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :instruction
      t.string :category
      t.string :area

      t.timestamps
    end
  end
end
