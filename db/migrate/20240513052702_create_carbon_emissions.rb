class CreateCarbonEmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :carbon_emissions do |t|
      t.decimal :carbonEmission
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
