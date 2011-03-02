class AddNotifiedNewFollowerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :notified_new_follower, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notified_new_follower
  end
end
