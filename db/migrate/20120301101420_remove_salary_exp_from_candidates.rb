class RemoveSalaryExpFromCandidates < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :salary_exp
  end

  def self.down
    add_column :events_candidates, :salary_exp, :string
  end
end
