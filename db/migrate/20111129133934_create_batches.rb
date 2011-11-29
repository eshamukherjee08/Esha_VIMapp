class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.integer :number
      t.datetime :start_time
      t.datetime :end_time
      t.integer :capacity
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :batches
  end
end
