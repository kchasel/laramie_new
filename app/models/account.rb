class Account < User

  scope :subscriber, where(:receive_news => true)
  
  # If the user created an account after having already been a subscriber, delete their subscriber account
  after_create :delete_if_subscribed
  
  has_many :comments, :dependent => :destroy
  
  validates_presence_of :firstname, :lastname, :salt, :message => "This is required."
  validates_presence_of :password, :password_confirmation, :if => :new_password, :message => "A password is required."
  validates_acceptance_of :terms_of_service, :message => "!= true"
  validates_length_of :password, :within => 5..40, :too_short => "Password must be at least {{count}} characters", 
    :too_long => "Password must be under {{count}} characters.", :if => :new_password
  validates_confirmation_of :password, :message => "Password and confirmation do not match."
  validates_presence_of :city, :if => Proc.new { |a| a.entering_address? or not a.city.blank?}, :message => "This is required if entering an address."
  validates_format_of :zip, :with => /^[\d]{5}$/, :message => "Zip code is not valid.", :if => Proc.new { |a| a.entering_address? or not a.zip.blank?}
  #validates_each :password do |user, attr, value|
    #user.errors.add attr, '== \'password\'' if value.downcase == 'password'
  #end
  
  attr_protected :admin, :id, :salt
  
  attr_accessor :password
  
  def subscribed?
    receive_news == true
  end
  
  def entering_address?
    if self.street1.blank? 
      return false
    else
      return true
    end
  end
  
  def new_password
    @new_password
  end
  
  def name=(name)
    @name = name
    split = name.split
    self.lastname = split.delete_at -1
    self.firstname = split.join(" ")
  end
  
  def name
    self.firstname + ' ' + self.lastname
  end
  
  def initials
    self.firstname[0,1] + self.lastname[0,1]
  end
  
  def self.emails
    self.select("email").collect { |a| a.email }
  end
  
  def delete_if_subscribed
    if s = Subscriber.find_by_email(email)
      s.destroy
    end
  end
  
  def self.authenticate(email, pass)
    u = where("email = ?", email).first
    return nil if u.nil? or u.verified == false
    return u if Account.encrypt(pass, u.salt)==u.hashed_password
    nil
  end

  
  def self.authenticate_by_token(id, token)
    u = where("id = ? AND security_token = ?", id, token).first
    return nil if u.nil?
    u.verify
    u
  end
  
  def verify
    self.update_attribute("verified", true)
  end
  
  def password=(pass)
    @password = pass
    self.salt = Account.random_string(10) if !self.salt?
    self.hashed_password = Account.encrypt(@password, self.salt)
    @new_password = true
  end
  
  def generate_new_password
    new_pass = Account.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    return new_pass
  end
  
  def generate_security_token(len)
    token = Account.random_string(len)
    self.update_attribute('security_token', token)
    return self.security_token
  end
  
  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  def self.random_string(len)
    # generates a random string consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
end