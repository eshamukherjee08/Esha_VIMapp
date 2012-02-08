class ChangeCategoryTypeInEvents < ActiveRecord::Migration
  def self.up
    change_column :events, :category, :integer
    rename_column :events, :category, :category_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
