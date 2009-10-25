class CreateWorktypes < ActiveRecord::Migration
  def self.up
    create_table :worktypes do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :worktypes
  end
end
