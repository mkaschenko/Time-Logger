class Task < ActiveRecord::Base
  
  validates_uniqueness_of :title
  
end
