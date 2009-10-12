class AddProjectAndWorkTypeColumns < ActiveRecord::Migration
  def self.up
    add_column :tasks, :project, :string, :default => ""
    add_column :tasks, :work_type, :string, :default => ""
  end

  def self.down
    remove_column :tasks, :work_type
    remove_column :tasks, :project
  end
end
