class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.decimal :amount
      t.string :stripeId
      t.boolean :isContinues
      t.boolean :isSuccess

      t.timestamps
    end
  end
end
