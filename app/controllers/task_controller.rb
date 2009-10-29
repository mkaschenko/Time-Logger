class TaskController < ApplicationController

  before_filter :authorize, :get_current_user

  def index
    # @tasks = @current_user.tasks.uncomplete_tasks
    # @complete_tasks = @current_user.tasks.complete_tasks
    # @active_task_id = false
    # respond_to do |wants|
      # wants.json { render :json => @current_user.tasks.to_json }
      # wants.html { render :action => "index" }
    # end
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
      # render :action => "index"
      # redirect_to :action => "index"
    else
      @task = Task.new(:title => prepared_data[:task])
      @task.user = @current_user
      @task.create_project_worktypes_user(prepared_data, @current_user)
      if @task.save
        # render :action => "index"
        # redirect_to :action => "index"
      else
        render :partial => "task_errors", :status => 500
      end
    end
    # params[:active_task_id] == "undefined" ? @active_task_id = false : @active_task_id = params[:active_task_id].to_i
    # if @task.save
    #   render :update do |page|
    #     page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => @current_user.tasks.uncomplete_tasks, :active_task_id => @active_task_id }
    #     page.select('div.inputError').hide()
    #     page.visual_effect(:highlight, "task_#{@task.id}", :duration => 1)
    #   end
    # else
  end

  def update
    # @task = Task.find(params[:id])
    # params[:active_task_id] == "undefined" ? @active_task_id = false : @active_task_id = params[:active_task_id].to_i
    # params[:task][:spent_time] = params[:task][:spent_time].to_i + @task.spent_time
    # @task.update_attributes(params[:task])
    # render :update do |page|
    #   page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => @current_user.tasks.uncomplete_tasks, :active_task_id => @active_task_id }
    #   page.replace_html 'complete_tasks_list', :partial => "list_complete", :locals => { :tasks => @current_user.tasks.complete_tasks }
    #   page.visual_effect(:pulsate, "task_#{@task.id}", :duration => 0.3)
    # end
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