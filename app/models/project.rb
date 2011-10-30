class Project < ActiveRecord::Base
  has_many :time_entries
  has_many :tasks
  has_and_belongs_to_many :users

  validates_uniqueness_of :name
  validates_presence_of :name
end
