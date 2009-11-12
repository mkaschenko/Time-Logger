class ChangeColumnTime < ActiveRecord::Migration
  def self.up
    change_column :time_entries, :time, :datetime
    rename_column :time_entries, :time, :end_on
  end

  def self.down
    rename_column :time_entries, :end_on, :time
    change_column :time_entries, :time, :integer
  end
end
