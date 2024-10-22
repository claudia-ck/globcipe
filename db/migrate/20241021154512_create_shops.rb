class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
