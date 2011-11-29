class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :name
      t.date :dob
      t.text :address
      t.string :current_state
      t.string :home_town
      t.string :email
      t.integer :mobile_num
      t.string :exp
      t.string :salary_exp
      t.integer :batch_id
      t.boolean :starred
      t.binary :resume, :limit => 1.megabyte

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
