class Subscriber < User
  
  validates_presence_of :email, :message => "A valid e-mail is required."
  
  def subscribed?
    true
  end
  
  def has_account?
    if Account.find_by_email(email)
      return true
    end
    return false
  end
  
  def self.emails
    Subscriber.select('email').collect { |s| s.email }
  end
  
end
