class Admin::MainController < ApplicationController

  before_filter :authenticate_admin
  
  layout 'admin/layouts/main'
    
    def index
    end
    
    def listhost_mail
      @message = params[:message] ? Message.new(params[:message]) : Message.new
    end
    
    def preview_message
      @message = Message.new(params[:message])
      if @message.invalid?
        render :action => 'listhost_mail'
      end
    end
    
    def send_listhost_message
      @message = Message.new(params[:message])
      if request.post?
        if @message.deliver_to_listhost
          flash[:notice] = "Your message was delivered."
          redirect_to :action => 'index'
        else
          render :action => 'listhost_mail'
        end
      end
    end
    
    
end
