class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.references :category, null: false, foreign_key: true
      t.string :featuredImage
      t.text :summary
      t.text :howItWork
      t.references :location, null: false, foreign_key: true
      t.integer :activeSince
      t.references :certification_type, null: false, foreign_key: true
      t.references :project_developer, null: false, foreign_key: true
      t.references :project_design_validator, null: false, foreign_key: true
      t.references :credits_validator, { foreign_key: true, null: false }
      t.string :readMore
      t.integer :totalCarbonCredits
      t.integer :allocatedCarbonCredits
      t.decimal :offsetRate

      t.timestamps
    end
  end
end
