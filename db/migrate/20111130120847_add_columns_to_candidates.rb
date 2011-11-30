class AddColumnsToCandidates < ActiveRecord::Migration
  def self.up
    change_table :candidates do |t|
      t.string :name
      t.date :dob
      t.text :address
      t.string :current_state
      t.string :home_town
      t.integer :mobile_number
      t.string :exp
      t.string :salary_exp
      t.boolean :starred
      t.integer :batch_id
      t.binary :resume, :limit => 1.megabyte
    end
  end

  def self.down
  end
end
