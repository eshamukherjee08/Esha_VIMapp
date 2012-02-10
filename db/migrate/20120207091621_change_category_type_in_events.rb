class ChangeCategoryTypeInEvents < ActiveRecord::Migration
  def self.up
    change_column :events, :category, :integer
    rename_column :events, :category, :category_id
    # Event.reset_column_information
    # Event.all.each do |element|
    #   if(element.category == 'Ruby On Rails Developer')
    #     @sql = "update events set category_id = '1' where id = '#{element.id}'"
    #   elsif(element.category == 'Android Developer')
    #     @sql = "update events_candidates set category_id = '2' where id = '#{element.id}'"
    #   elsif(element.category == 'PHP Developer')
    #     @sql = "update events_candidates set category_id = '3' where id = '#{element.id}'"
    #   elsif(element.category == 'Project Manager')
    #     @sql = "update events_candidates set category_id = '4' where id = '#{element.id}'"
    #   end
    #   execute(@sql)
    # end
  end

  def self.down
    rename_column :events, :category_id, :category
    change_column :events, :category, :string
    # Event.reset_column_information
    # Event.all.each do |element|
    #   if(element.category_id == '1')
    #     @sql = "update events set category = 'Ruby On Rails Developer' where id = '#{element.id}'"
    #   elsif(element.category_id == '2')
    #     @sql = "update events_candidates set category = 'Android Developer' where id = '#{element.id}'"
    #   elsif(element.category_id == '3')
    #     @sql = "update events_candidates set category = 'PHP Developer' where id = '#{element.id}'"
    #   elsif(element.category_id == '4')
    #     @sql = "update events_candidates set category = 'Project Manager' where id = '#{element.id}'"
    #   end
    #   execute(@sql)
    # end
  end
end
