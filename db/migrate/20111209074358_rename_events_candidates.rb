class RenameEventsCandidates < ActiveRecord::Migration
  def self.up
    rename_table :events_candidates, :events_candidate
  end

  def self.down
  end
end
