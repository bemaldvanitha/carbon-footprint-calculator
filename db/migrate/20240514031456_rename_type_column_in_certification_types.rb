class RenameTypeColumnInCertificationTypes < ActiveRecord::Migration[7.1]
  def change
    rename_column :certification_types, :type, :certification_type
  end
end
