class ChangeTypeInEvents < ActiveRecord::Migration
  def self.up
    change_column :events, :catagory, :integer
    change_column :events, :experience, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
