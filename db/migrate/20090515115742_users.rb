class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :email
      t.string  :firstname
      t.string  :lastname
      t.string  :street1
      t.string  :street2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :hashed_password
      t.string  :security_token
      t.string  :salt
      t.boolean :verified, :default => false
      t.string  :type
      t.boolean :receive_news
      t.boolean :no_emails
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
