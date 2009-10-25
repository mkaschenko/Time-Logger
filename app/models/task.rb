class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :time_entries
  has_and_belongs_to_many :worktype

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :project_id

  def full_title=(title)
    title.strip!
    title.gsub!(/\s{2,}/, " ") # replace two and more whitespaces on a whitespace
    project = title.scan(/^\[.+\]/)
    self.project = project.to_s.sub("[", "").chop
    title.gsub!(project.to_s, "")
    work_type = title.scan(/@.+$/)
    self.work_type = work_type.to_s.sub("@", "")
    title.gsub!(work_type.to_s, "")
    self.title = title.strip
  end

  def self.uncomplete_tasks
    find(:all, :conditions => ['complete = ?', false], :group => 'title')
  end

  def self.complete_tasks
    find(:all, :conditions => ['complete = ?', true], :group => 'title')
  end

end