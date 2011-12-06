class AddToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :email, :string
    change_column :candidates, :confirmed, :boolean, :default => false
  end

  def self.down
  end
end
