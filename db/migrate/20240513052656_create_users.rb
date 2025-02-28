class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :phoneNumber
      t.string :fullName
      t.references :user_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
