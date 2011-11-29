class Batch < ActiveRecord::Base
  belongs_to :event
  has_many :candidates
end
