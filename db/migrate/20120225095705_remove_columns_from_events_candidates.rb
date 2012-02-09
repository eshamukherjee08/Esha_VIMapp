class RemoveColumnsFromEventsCandidates < ActiveRecord::Migration
  def self.up
    remove_column :events_candidates, :confirmed
    remove_column :events_candidates, :attended
    remove_column :events_candidates, :waitlist
    remove_column :events_candidates, :cancellation
    remove_column :events_candidates, :status
  end

  def self.down
    add_column :events_candidates, :confirmed, :boolean
    add_column :events_candidates, :attended, :boolean
    add_column :events_candidates, :waitlist, :boolean
    add_column :events_candidates, :cancellation, :boolean
    add_column :events_candidates, :status, :boolean
  end
end
