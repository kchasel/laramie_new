class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :summary
      t.text :body
      t.boolean :important, :default => false
      t.boolean :nocomments, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
