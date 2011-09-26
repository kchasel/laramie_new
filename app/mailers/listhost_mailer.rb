class ListhostMailer < ActionMailer::Base
  
  helper :mailer
  
  self.delivery_method = :active_record
  
  default :from => Laramie::CONFIG[:steering_email]
  
  layout 'layouts/listhost_mailer'
  
  def article(article, email)
    @article = article
    if article.image.file?
      attachments.inline['image.jpg'] = File.read(article.image.url(:thumb))
    end
    mail(:subject => "[NLRA] #{article.title}", :to => email)
  end
  
  def single_message(message, email)
    @title = message.subject
    @text = message.body
    mail(:subject => "[NLRA] #{@title}", :to => email) do |format|
      format.text { render 'message' }
      format.html { render 'message' }
    end
  end
  
  def single_message_attached(message, email, att_bodies)
    @title = message.subject
    @text = message.body
    message.attachments.each_with_index do |a, i|
      attachments[a.original_filename] = att_bodies[i]
    end
    mail(:subject => "[NLRA] #{@title}", :to => email) do |format|
      format.text { render 'message' }
      format.html { render 'message' }
    end
  end
  
end
