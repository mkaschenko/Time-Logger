class CreateTasksWorktypes < ActiveRecord::Migration
  def self.up
    create_table :tasks_worktypes, :id => false do |t|
      t.integer :task_id
      t.integer :worktype_id
    end
  end

  def self.down
    drop_table :tasks_worktypes
  end
end
