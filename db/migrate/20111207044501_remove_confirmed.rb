class RemoveConfirmed < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :confirmed
  end

  def self.down
    add_column :candidates, :confirmed, :boolean
  end
end
