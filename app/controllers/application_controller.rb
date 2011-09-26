# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # if using SSL, uncomment below and use helper methods ssl_required or ssl_allowed in controllers
  # include SslRequirement
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd4dbab68b58a5a0335d9e8266bf6ff87'
  
  # user name and password to access the admin interface
  USER_NAME, PASSWORD = Laramie::CONFIG[:username], Laramie::CONFIG[:pw]
  
  # To apply the username and password above to the entire site, uncomment below
  # before_filter :authenticate_admin
  

# Accounts and logins have been disabled in this version of the NLRA site
=begin  def login_required
    flash.keep
    if session[:account]
      return true
    end
    #check to see if a token's being used
    if params[:account] and id = params[:account][:id] and key = params[:key]
      session[:account] = User.authenticate_by_token(id, key)
      return true if not session[:account].nil?
      flash[:warning] = "Your security key is invalid or has expired. <a href='#{url_for :action => "send_new_verifier", :controller => "account"}'>
      Get a new one here</a>."
    end
    store_location
    redirect_to :controller => 'accounts', :action => 'login'
    return false
  end
=end  

  def rightbar_support
    #@first_event = Event.first.order("start_at ASC").where("start_at > ?", 2.hours.ago)
    #@subscriber = Subscriber.new
    #@month = 7#(params[:month] || Time.zone.now.month).to_i
    #@year = 2010#(params[:year] || Time.zone.now.year).to_i
    # @events = Calendar.get_events(@year, @month)
    @tweets = Tweet.order('created_at DESC').limit(3)
    @rightbar_visible = true
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
=begin  def current_user
    session[:account] if session[:account] != "notverified"
  end
  
  helper_method :current_user
=end
  
  def redirect_back_or_default(default)
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to return_to
    else
      redirect_to default
    end
  end
  
  private
    def authenticate_admin
      authenticate_or_request_with_http_basic "Login required to access this content" do |user_name, password|
          user_name == USER_NAME && password == PASSWORD
      end
    end
  
end