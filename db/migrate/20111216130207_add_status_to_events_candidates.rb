class AddStatusToEventsCandidates < ActiveRecord::Migration
  def self.up
    add_column :events_candidates, :status, :boolean
  end

  def self.down
  end
end
