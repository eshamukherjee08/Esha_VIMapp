class AddTokenCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :perishable_token, :string
  end

  def self.down
  end
end
