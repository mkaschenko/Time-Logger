class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.integer :project_id
      t.integer :user_id,     :null => false
      t.integer :task_id,     :null => false
      t.integer :worktype_id
      t.float   :hours
      t.date    :spent_on,    :null => false
      t.integer :year,        :null => false
      t.integer :month,       :null => false
      t.integer :week,        :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :time_entries
  end
end
