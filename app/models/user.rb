class User < ActiveRecord::Base
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "A valid e-mail is required."
  validates_uniqueness_of :email, :message => "This e-mail is already assigned to an account.", :unless => Proc.new { |a| a.subscriber_to_account }
  validates_presence_of :type, :message => "must be one of Subscriber or Account."
  
  def self.listhost_emails
    Subscriber.emails + Account.subscriber.emails
  end
  
  def self.listhost_count
    Subscriber.count + Account.subscriber.count
  end
    
  # If the User to be added will be an Account AND the e-mail is already a Subscriber, then override the uniqueness check
  def subscriber_to_account
    return true if Subscriber.find_by_email(email) and self.is_a?(Account)
    return false
  end
  
end