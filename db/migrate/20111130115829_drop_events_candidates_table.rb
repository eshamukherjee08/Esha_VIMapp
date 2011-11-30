class DropEventsCandidatesTable < ActiveRecord::Migration
  def self.up
    drop_table :events_candidates
  end

  def self.down
  end
end
