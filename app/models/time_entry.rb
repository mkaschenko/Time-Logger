class TimeEntry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :task
  belongs_to :worktype

  def fill_dates
    date = Time.now
    self.spent_on = date
    self.year = date.year
    self.month = date.month
    self.week = date.strftime("%W")
  end
end
