class AddTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :tweets
  end
end
