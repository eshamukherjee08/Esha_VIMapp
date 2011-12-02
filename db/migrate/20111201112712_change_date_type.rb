class ChangeDateType < ActiveRecord::Migration
  def self.up
    change_column :events, :event_date, :datetime
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
