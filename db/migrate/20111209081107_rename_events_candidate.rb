class RenameEventsCandidate < ActiveRecord::Migration
  def self.up
    rename_table :events_candidate, :events_candidates
  end

  def self.down
  end
end
