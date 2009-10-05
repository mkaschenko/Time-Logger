class TaskController < ApplicationController

  def index
    @tasks = Task.find(:all, :group => "title")
  end

  def create
    @task = Task.new(params[:task])
    @task.save
    render :partial => "list", :locals => { :tasks => Task.find(:all, :group => "title") }
  end

end
