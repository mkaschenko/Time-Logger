class TaskController < ApplicationController

  def index
    @tasks = Task.find_uncomplete_tasks
    @complete_tasks = Task.find_complete_tasks
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      render :update do |page|
        page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => Task.find_uncomplete_tasks }
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
    @task.update_attribute(:complete, params[:complete])
    render :update do |page|
      page.replace_html 'tasks_list', :partial => "list", :locals => { :tasks => Task.find_uncomplete_tasks }
      page.replace_html 'list_complete', :partial => "list_complete", :locals => { :tasks => Task.find_complete_tasks }
      page.visual_effect(:highlight, "task_#{@task.id}", :duration => 1)
    end
  end

end