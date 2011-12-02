class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches, :dependent => :destroy
  #has_and_belongs_to_many :candidates
end
