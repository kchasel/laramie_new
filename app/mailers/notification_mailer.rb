class NotificationMailer < ActionMailer::Base
  
  layout 'layouts/notification_mailer'
  
  default :from => Laramie::CONFIG[:noreply_email]
  
  def subscribe_notification(user)
    @user = user
    mail(:subject => "[NLRA] Subscription to the NLRA Listhost", :to => user.email)
  end
  
  def unsubscribe_notification(user)
    @user = user
    mail(:subject => "[NLRA] Unsubscription from the NLRA Listhost", :to => user.email)
  end
  
end
