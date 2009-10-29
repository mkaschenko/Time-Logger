class Worktype < ActiveRecord::Base
  has_many :time_entries
  has_and_belongs_to_many :task
  
  validates_uniqueness_of :name
  validates_presence_of :name
end
