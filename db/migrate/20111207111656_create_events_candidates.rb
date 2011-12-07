class CreateEventsCandidates < ActiveRecord::Migration
  def self.up
    create_table :events_candidates do |t|
      t.integer :event_id
      t.integer :candidate_id
      t.integer :roll_num
      t.boolean :confirmed, :default => false
      t.boolean :attended, :default => false
      t.boolean :waitlist, :default => false
      t.boolean :cancellation, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :events_candidates
  end
end
