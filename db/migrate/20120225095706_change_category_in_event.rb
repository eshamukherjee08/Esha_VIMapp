class ChangeCategoryInEvent < ActiveRecord::Migration
  def self.up
    change_column :events, :category, :integer
  end

  def self.down
    change_column :events, :category, :string
  end
end
