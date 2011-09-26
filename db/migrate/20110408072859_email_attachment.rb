class EmailAttachment < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE emails CHANGE mail mail LONGTEXT"
  end

  def self.down
    execute "ALTER TABLE emails CHANGE mail mail TEXT"
  end
end
