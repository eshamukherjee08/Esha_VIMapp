class RemoveResumeFromCandidates < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :resume
  end

  def self.down
  end
end
