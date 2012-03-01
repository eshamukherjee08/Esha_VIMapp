class RenameColumns < ActiveRecord::Migration
  def self.up
    rename_column :events, :event_date, :scheduled_at
    rename_column :events_candidates, :current_state, :state
    rename_column :candidates, :current_state, :residing_state
  end

  def self.down
    rename_column :events, :scheduled_at, :event_date
    rename_column :events_candidates, :state,  :current_state
    rename_column :candidates, :residing_state, :current_state
  end
end
