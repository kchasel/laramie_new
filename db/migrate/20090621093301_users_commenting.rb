class UsersCommenting < ActiveRecord::Migration
  def self.up
    add_column :users, :no_comments, :boolean, :default => false
  end

  def self.down
    drop_column :users, :no_comments
  end
end
