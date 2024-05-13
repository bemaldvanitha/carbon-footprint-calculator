class CreateTemporaryUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :temporary_users do |t|
      t.string :ipAddress
      t.decimal :carbonEmission

      t.timestamps
    end
  end
end
