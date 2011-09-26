class MainController < ApplicationController
  
  before_filter :rightbar_support, :except => [:about, :info_link]
  
  def index
    store_location
    @articles = Article.order("created_at DESC").limit(4)
    @num_photos = 32
    render :layout => false
  end
  
  def donate
    respond_to do |format|
      format.js
      format.html # index.html.erb
    end
  end
  
  def documents
  end
  
  def petitions
  end
  
  def legal
  end
  
  def subscribe
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  # Tab changer for About page
  def info_link
    sec = params[:sec]
    render :partial => "main/tabs/#{sec}"
  end
  
end
