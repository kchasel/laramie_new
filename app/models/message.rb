class Message
  
  include ActiveModel::Validations
  
  attr_accessor :subject, :body, :attachments
  
  validates_each :subject, :body do |record, attr, value|
    record.errors.add attr, "can't be blank." if value.blank?
  end
  
  def initialize(params={})
    if not params.empty?
      @subject = params[:subject]
      @body = params[:body]
      @attachments = params[:attachment]
    end
  end
  
  def deliver_to_listhost
    addresses = User.listhost_emails
    if self.attachments.blank?
      addresses.each do |a|
        ListhostMailer.single_message(self, a).deliver
      end
    else
      att_bodies = []
      self.attachments.each { |a| att_bodies << a.read }
      addresses.each do |a|
        ListhostMailer.single_message_attached(self, a, att_bodies).deliver
      end
    end
    return true
  end
  
  handle_asynchronously :deliver_to_listhost
  
end