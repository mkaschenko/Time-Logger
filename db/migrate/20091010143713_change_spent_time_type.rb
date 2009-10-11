class ChangeSpentTimeType < ActiveRecord::Migration
  def self.up
    change_column :tasks, :spent_time, :integer, :default => 0
  end

  def self.down
    change_column :tasks, :spent_time, :time, :default => 0
  end
end
