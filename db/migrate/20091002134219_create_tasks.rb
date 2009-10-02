class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title, :null => false
      t.time :spent_time, :default => 0
      t.boolean :complete, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
