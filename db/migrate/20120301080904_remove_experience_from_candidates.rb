class RemoveExperienceFromCandidates < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :exp
  end

  def self.down
    add_column :candidates, :exp
  end
end
