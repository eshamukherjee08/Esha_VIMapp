class RemoveResumeColumnsFromCandidates < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :resume_file_name
    remove_column :candidates, :resume_content_type
    remove_column :candidates, :resume_file_size
  end

  def self.down
    add_column :candidates, :resume_file_name, :string
    add_column :candidates, :resume_content_type, :string
    add_column :candidates, :resume_file_size, :integer
  end
end
