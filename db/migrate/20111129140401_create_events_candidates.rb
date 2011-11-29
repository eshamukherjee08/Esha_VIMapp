class CreateEventsCandidates < ActiveRecord::Migration
  def self.up
    create_table :events_candidates, :id => false do |t|
      t.integer :event_id
      t.integer :candidate_id
      t.boolean :attended
      t.boolean :waitlist
      t.boolean :cancellation
    end
  end

  def self.down
    drop_table :events_candidates
  end
end
