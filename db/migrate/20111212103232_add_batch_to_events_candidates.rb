class AddBatchToEventsCandidates < ActiveRecord::Migration
  def self.up
    add_column :events_candidates, :batch_id, :integer
  end

  def self.down
  end
end
