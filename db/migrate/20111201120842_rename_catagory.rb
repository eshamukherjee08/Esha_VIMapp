class RenameCatagory < ActiveRecord::Migration
  def self.up
    rename_column :events, :catagory, :category
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
