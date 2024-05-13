class CreateCreditsValidators < ActiveRecord::Migration[7.1]
  def change
    create_table :credits_validators do |t|
      t.string :name
      t.string :organization

      t.timestamps
    end
  end
end
