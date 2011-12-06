class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :name
      t.date :dob
      t.text :address
      t.string :current_state
      t.string :home_town
      t.integer :mobile_number
      t.string :exp
      t.string :salary_exp
      t.boolean :starred
      t.boolean :confirmed
      t.integer :batch_id
      t.binary :resume, :limit => 1.megabyte

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
