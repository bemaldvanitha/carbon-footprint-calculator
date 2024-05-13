class CreateTechnicalDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :technical_documents do |t|
      t.string :document
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
