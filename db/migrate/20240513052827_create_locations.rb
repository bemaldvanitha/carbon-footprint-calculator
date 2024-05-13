class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
