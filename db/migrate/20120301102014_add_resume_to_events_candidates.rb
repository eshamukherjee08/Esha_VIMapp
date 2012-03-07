class AddResumeToEventsCandidates < ActiveRecord::Migration
  def self.up
    add_column :events_candidates, :resume_file_name, :string
    add_column :events_candidates, :resume_content_type, :string
    add_column :events_candidates, :resume_file_size, :integer
    EventsCandidate.reset_column_information

    # Can be done with a single loop -> please correct
    Candidate.all.each do |candidate|
      EventsCandidate.where(:candidate_id => candidate.id).update_attributes(:resume_file_name => candidate.resume_file_name, :resume_content_type => candidate.resume_content_type, :resume_file_size => candidate.resume_file_size)
    end
  end

  def self.down
    remove_column :events_candidates, :resume_file_name
    remove_column :events_candidates, :resume_content_type
    remove_column :events_candidates, :resume_file_size
  end
end
