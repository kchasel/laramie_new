class SubscribersController < ApplicationController
  
  layout 'main'
  
  before_filter :rightbar_support, :except => [:create]
  
  def create
    @subscriber = Subscriber.new(params[:subscriber])
    if u = User.find_by_email(@subscriber.email)
      a = u if u.is_a?(Account)
      s = u if u.is_a?(Subscriber)
      if a and not a.receive_news
        a.update_attribute(:receive_news, true)
        NotificationMailer.subscribe_notification(@subscriber).deliver
        flash[:subscriber] = a.email
        respond_to do |format|
          format.js { render 'success' } 
          format.html { redirect_to :action => "thanks" }
        end
      else
        @subscriber = u
        respond_to do |format|
          format.js { render 'already_subscribed' }
          format.html { redirect_to :action => 'already_subscribed', :id => @subscriber.id }
        end
      end
    else
      if @subscriber.save
        NotificationMailer.subscribe_notification(@subscriber).deliver
        flash[:subscriber] = @subscriber.email
        respond_to do |format|
          format.js { render 'success' }
          format.html { redirect_to :action => "thanks" }
        end
      else
        respond_to do |format|
          format.js { render 'try_again' }
          format.html { flash[:notice] = "The e-mail you entered was not valid. Please try again below."
            redirect_to :action => "assistance" }
        end
      end
    end
  end
  
  def thanks
    unless flash[:subscriber]
      redirect_to :action => "assistance" and return
    end
    @email = flash[:subscriber]
  end
  
  def already_subscribed
    @subscriber = User.find(params[:id])
  end
  
  def unsubscribe
    if request.post?
      u = User.find_by_email(params[:email])
      if u.blank? or u.receive_news == false
        respond_to do |format|
          format.js
          format.html { flash.now[:notice] = "The e-mail you entered is not in our system." }
        end
        return
      end
      @deleted = u
      if u.is_a?(Subscriber)
        u.destroy
      elsif u.is_a?(Account)
        u.update_attribute(:receive_news, false)
      end
      NotificationMailer.unsubscribe_notification(@deleted).deliver
      respond_to do |format|
        flash[:user] = @deleted
        format.js { render 'unsubscribed' }
        format.html { redirect_to :action => 'removed' }
      end
    end
  end
  
  def removed
    if flash[:user] == nil
      redirect_to :action => 'unsubscribe' and return
    end
    @email = flash[:user].email
  end
  
end
