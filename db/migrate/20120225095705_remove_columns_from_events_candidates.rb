class RemoveColumnsFromEventsCandidates < ActiveRecord::Migration
  def self.up
    EventsCandidate.reset_column_information
    EventsCandidate.all.each do |element|
      if(element.confirmed and element.waitlist)
        @sql = "update events_candidates set current_state = 'waitlisted' where id = '#{element.id}'"
      elsif(element.confirmed and element.attended and element.status == nil)
        @sql = "update events_candidates set current_state = 'attended' where id = '#{element.id}'"
      elsif(element.confirmed and element.attended and element.status)
        @sql = "update events_candidates set current_state = 'selected' where id = '#{element.id}'"
      elsif(element.confirmed and element.attended and !element.status)
        @sql = "update events_candidates set current_state = 'rejected' where id = '#{element.id}'"
      elsif(element.confirmed and element.cancellation)
        @sql = "update events_candidates set current_state = 'cancelled' where id = '#{element.id}'"
      elsif(element.confirmed and !element.attended and element.status == nil and !element.waitlist and !element.cancellation)
        @sql = "update events_candidates set current_state = 'alloted' where id = '#{element.id}'"
      end
    end
    remove_column :events_candidates, :confirmed
    remove_column :events_candidates, :attended
    remove_column :events_candidates, :waitlist
    remove_column :events_candidates, :cancellation
    remove_column :events_candidates, :status
  end

  def self.down
    add_column :events_candidates, :confirmed, :boolean
    add_column :events_candidates, :attended, :boolean
    add_column :events_candidates, :waitlist, :boolean
    add_column :events_candidates, :cancellation, :boolean
    add_column :events_candidates, :status, :boolean
    EventsCandidate.all.each do |element|
      if(element.current_state == 'waitlisted')
        @sql = "update events_candidates set confirmed = 'true', waitlist = 'true' where id = '#{element.id}'"
      elsif(element.current_state == 'attended')
        @sql = "update events_candidates set confirmed = 'true', attended = 'true', status = 'nil' where id = '#{element.id}'"
      elsif(element.current_state == 'selected')
        @sql = "update events_candidates set confirmed = 'true', attended = 'true', status = 'true' where id = '#{element.id}'"
      elsif(element.current_state == 'rejected')
        @sql = "update events_candidates set confirmed = 'true', attended = 'true', status = 'false' where id = '#{element.id}'"
      elsif(element.current_state == 'cancelled')
        @sql = "update events_candidates set confirmed = 'true', cancellation = 'true' where id = '#{element.id}'"
      elsif(element.current_state == 'alloted')
        @sql = "update events_candidates set confirmed = 'true', attended = 'false', status = 'nil', cancellation = 'false', waitlist = 'false' where id = '#{element.id}'"
      end
    end
  end
end
