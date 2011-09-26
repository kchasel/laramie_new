class Admin::UsersController < ApplicationController
  
  layout 'admin/layouts/main'
  
  before_filter :authenticate_admin
  
  def index
    @subscribers = Subscriber.order('created_at')
    @accounts = Account.all
    @users = @subscribers + @accounts
    @listhost_count = User.listhost_count
    @bad_emails = session[:bad_emails] unless session[:bad_emails].blank?
    session[:bad_emails] = nil
  end
  
  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:notice] = "User was deleted."
      redirect_to admin_users_path
    end
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def delete_all_comments
    user = User.find(params[:id])
    if user.comments.delete_all
      flash[:notice] = "All comments deleted."
    else
      flash[:notice] = "There was an error. Please contact the webmaster."
    end
    redirect_to admin_user_path(user)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated."
    else
      flash[:notice] = "There was an error updating this user's information."
    end
    redirect_to admin_user_path(@user)
  end
  
  def postal_list
    @accounts = Account.where("street1 != ''")
  end
  
  def bulk_emails
    if request.post?
      array = params[:emails].split(/,\s*/)
      good_emails, bad_emails = [], []
      array.each do |e|
        if (e =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i) != nil
          good_emails << e
        else
          bad_emails << e
        end
      end
      good_emails.each do |e|
        unless Subscriber.new(:email => e).save
          bad_emails << e
        end
      end
      flash[:notice] = "All emails were added to the subscriber list." if bad_emails.blank?
      flash[:notice] = "All emails were added to the subscriber list EXCEPT THOSE LISTED BELOW!" unless bad_emails.blank?
      session[:bad_emails] = bad_emails
      logger.info "[INFO] E-Mails not added: #{bad_emails.each { |m| print m + " -- "} }"
      redirect_to admin_users_path
    end
  end
  
  def delete_multiple
    Subscriber.delete(params[:to_delete]) if params[:to_delete]
    flash[:notice] = "All of the selected subscribers were deleted."
    redirect_to :action => :index
  end
  
end
