class TaskController < ApplicationController

  def index
    @tasks = Task.find_uncomplete_tasks
    @complete_tasks = Task.find_complete_tasks
    @active_task_id = false
  end

  def create
    @task = Task.new(params[:task])
    params[:active_task_id] == "undefined" ? @active_task_id = false : @active_task_id = params[:active_task_id].to_i
    if @task.save
      render :update do |page|
        page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => Task.find_uncomplete_tasks, :active_task_id => @active_task_id }
        page.select('div.inputError').hide()
        page.visual_effect(:highlight, "task_#{@task.id}", :duration => 1)
      end
    else
      render :update do |page|
        page.replace_html 'task_error', (error_message_on(:task, :title, :prepend_text => "Title ", :css_class => "inputError"))
      end
    end
  end

  def update
    @task = Task.find(params[:id])
    params[:active_task_id] == "undefined" ? @active_task_id = false : @active_task_id = params[:active_task_id].to_i
    params[:task][:spent_time] = params[:task][:spent_time].to_i + @task.spent_time
    @task.update_attributes(params[:task])
    render :update do |page|
      page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => Task.find_uncomplete_tasks, :active_task_id => @active_task_id }
      page.replace_html 'complete_tasks_list', :partial => "list_complete", :locals => { :tasks => Task.find_complete_tasks }
      page.visual_effect(:pulsate, "task_#{@task.id}", :duration => 0.3)
    end
  end

end