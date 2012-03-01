class AddSalaryExpectedToEventsCandidates < ActiveRecord::Migration
  def self.up
    add_column :events_candidates, :salary_exp, :string
    EventsCandidate.reset_column_information
    EventsCandidate.all.each do |element|
      Candidate.all.each do |candidate|
        if(element.candidate_id == candidate.id)
          @sql = "update events_candidates set salary_exp = '#{candidate.salary_exp}' where candidate_id = '#{candidate.id}'"
        end
      end
      execute(@sql) 
    end
  end

  def self.down
    remove_column :events_candidates, :salary_exp
  end
end
