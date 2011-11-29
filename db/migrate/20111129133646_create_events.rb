class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :event_date
      t.string :name
      t.string :experience
      t.string :location
      t.string :description
      t.string :catagory
      t.string :tech_spec
      t.integer :admin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
