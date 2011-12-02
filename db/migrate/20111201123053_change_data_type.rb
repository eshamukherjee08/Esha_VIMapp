class ChangeDataType < ActiveRecord::Migration
  def self.up
    change_column :events, :category, :string
    change_column :events, :experience, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
