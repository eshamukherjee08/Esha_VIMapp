class DropCandidateTable < ActiveRecord::Migration
  def self.up
    drop_table :candidates
  end

  def self.down
  end
end
