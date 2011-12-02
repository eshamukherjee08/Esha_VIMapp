class Batch < ActiveRecord::Base
  belongs_to :event, :depended => :destroy
  has_many :candidates
end
