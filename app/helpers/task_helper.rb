module TaskHelper

  def active_task?(active_task_id, task_id)
    "active" if active_task_id && active_task_id == task_id
  end

end
