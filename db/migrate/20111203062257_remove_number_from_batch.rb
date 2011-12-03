class RemoveNumberFromBatch < ActiveRecord::Migration
  def self.up
    remove_column :batches, :number
  end

  def self.down
    add_column :batches, :number, :integer
  end
end
