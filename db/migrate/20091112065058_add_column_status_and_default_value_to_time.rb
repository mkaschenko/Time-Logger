class AddColumnStatusAndDefaultValueToTime < ActiveRecord::Migration
  def self.up
    add_column :time_entries, :status, :boolean, :default => 0
    change_column :time_entries, :time, :integer, :default => 0
  end

  def self.down
    change_column :time_entries, :time, :integer
    remove_column :time_entries, :status
  end
end
