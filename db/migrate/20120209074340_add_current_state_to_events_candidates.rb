class AddCurrentStateToEventsCandidates < ActiveRecord::Migration
  def self.up
    add_column :events_candidates, :current_state, :string
  end

  def self.down
    remove_column :events_candidates, :current_state
  end
end
