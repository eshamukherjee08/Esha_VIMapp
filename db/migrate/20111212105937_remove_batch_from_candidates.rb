class RemoveBatchFromCandidates < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :batch_id
  end

  def self.down
  end
end
