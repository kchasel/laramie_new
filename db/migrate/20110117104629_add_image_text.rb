class AddImageText < ActiveRecord::Migration
  def self.up
    add_column :articles, :image_text, :text
  end

  def self.down
    remove_column :articles, :image_text
  end
end
