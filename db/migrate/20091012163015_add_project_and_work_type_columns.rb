class AddProjectAndWorkTypeColumns < ActiveRecord::Migration
  def self.up
    add_column :tasks, :project, :string
    add_column :tasks, :work_type, :string
  end

  def self.down
    remove_column :tasks, :work_type
    remove_column :tasks, :project
  end
end
