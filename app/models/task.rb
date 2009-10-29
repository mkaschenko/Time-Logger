class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :time_entries
  has_and_belongs_to_many :worktype

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :project_id

  def create_project_worktypes_user(prepared_data, current_user)
    unless prepared_data[:task].empty?
      project = Project.find_or_create_by_name(prepared_data[:project])
      if project.id
        self.project = project
        current_user.project << project
      end
      prepared_data[:worktypes].each { |worktype| self.worktype << Worktype.find_or_create_by_name(worktype) }
    end
  end

  def update_worktypes(worktypes)
    unless worktypes.empty?
      current_worktypes = []
      self.worktype.each { |worktype| current_worktypes << worktype.name }
      worktypes_to_update = worktypes - current_worktypes
      worktypes_to_update.each { |name| self.worktype << Worktype.find_or_create_by_name(name) }
    end
  end

  # def self.uncomplete_tasks
  #   find(:all, :conditions => ['complete = ?', false], :group => 'title')
  # end
  # 
  # def self.complete_tasks
  #   find(:all, :conditions => ['complete = ?', true], :group => 'title')
  # end

end