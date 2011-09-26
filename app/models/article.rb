class Article < ActiveRecord::Base
  
  # Order all articles retrieved in descending order
  default_scope :order => "created_at DESC"
  
  # Add an associated image using Paperclip
  has_attached_file :image, :styles => { :big => "800x600", :small => "300x225", :thumb => "150"}
  
  validates_presence_of :title, :summary, :body
  
  attr_accessor :no_mail
  
  has_many :comments, :dependent => :destroy
  
  def deliver_to_listhost
    addresses = User.listhost_emails
    addresses.each do |a|
      ListhostMailer.article(self, a).deliver
    end
  end
  
  # Listhost deliveries are always handled separately by the delayed_job gem
  handle_asynchronously :deliver_to_listhost
  
end
