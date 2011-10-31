class TaskController < ApplicationController

  before_filter :authorize, :get_current_user

  def index
    @tasks = @current_user.tasks
    respond_to do |wants|
      wants.html { }
      wants.json { }
    end
  end

  def create
    prepared_data = cut_title(params[:task][:title])
    if prepared_data[:project].empty?
      conditions = [ 'project_id is ?', nil ]
    else
      conditions = [ 'project_id = ?', Project.find_by_name(prepared_data[:project]) ]
    end
    @task = Task.find_by_title(prepared_data[:task], :conditions => conditions)
    if @task
      @task.update_worktypes(prepared_data[:worktypes])
    else
      @task = Task.new(:title => prepared_data[:task])
      @task.user = @current_user
      @task.create_project_worktypes_user(prepared_data, @current_user)
      unless @task.save
        render :partial => "task_errors", :status => 500 and return
      end
    end
    render :nothing => true
  end

  def update
    task = Task.find(params[:id])
    if params[:task]
      task.update_attributes(params[:task])
    end
    if params[:time_entry]
      if params[:time_entry][:status]
        time_entry = task.time_entries.find(:first, :conditions => ["user_id = ? and status = ?", @current_user, 0])
        time_entry.end_on = Time.now
        time_entry.update_attributes(params[:time_entry])
      else
        time_entry = task.time_entries.build(params[:time_entry])
        time_entry.user_id = task.user_id
        time_entry.project_id = task.project_id
        time_entry.fill_dates
        time_entry.save
      end
    end
    render :nothing => true
  end

  def ping
    time_entry = TimeEntry.find(:first, :conditions => ["user_id = ? and task_id = ? and status = ?",
                                                        @current_user, params[:id], 0])
    time_entry.end_on = Time.now
    time_entry.save
    render :nothing => true
  end

  def cut_title(title)
    title.strip!
    title.gsub!(/\s{2,}/, " ") # replace two and more whitespaces on a whitespace
    project = title.scan(/^\[\w*\]/)
    title.sub!(project.to_s, "")
    project = project.to_s.sub("[", "").chop
    worktypes = title.scan(/@\w+/)
    worktypes.each { |worktype| title.sub!(worktype.to_s, "") }
    worktypes.collect! { |worktype| worktype.to_s.sub("@", "") }
    task = title.strip
    { :project => project, :task => task, :worktypes => worktypes }
  end

  private

  def authorize
    redirect_back_or_default('/') unless logged_in?
  end

  def get_current_user
    @current_user = current_user
  end

end