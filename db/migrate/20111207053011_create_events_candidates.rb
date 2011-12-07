class CreateEventsCandidates < ActiveRecord::Migration
  def self.up
    create_table :events_candidates, :id => true do |t|
      t.integer :event_id
      t.integer :candidate_id
      t.integer :roll_num
      t.boolean :confirmed, :default => false
      t.boolean :attended, :default => false
      t.boolean :waitlist, :default => false
      t.boolean :cancellation, :default => false
    end
  end

  def self.down
  end
end
