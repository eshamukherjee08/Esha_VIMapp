class RenameCategoryInEvent < ActiveRecord::Migration
  def self.up
    rename_column :events, :category, :category_id
  end

  def self.down
    rename_column :events, :category_id, :category
  end
end
