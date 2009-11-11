class RenameColumnHoursAndChangeType < ActiveRecord::Migration
  def self.up
    rename_column :time_entries, :hours, :time
    change_column :time_entries, :time, :integer, :null => false
  end

  def self.down
    change_column :time_entries, :time, :float, :null => true
    rename_column :time_entries, :time, :hours
  end
end
