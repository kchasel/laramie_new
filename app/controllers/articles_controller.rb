class ArticlesController < ApplicationController
  
  layout 'main', :only => [:index, :show]
  
  before_filter :rightbar_support, :only => [:index]
  
  # GET /articles
  # GET /articles.xml
  def index
    # limit added to make offset work
    @articles = Article.order("created_at DESC")
    block = Proc.new { |a| Time.local(a.created_at.year, a.created_at.month)}
    @month_articles = @articles.group_by(&block)
    #debugger
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

end

# Custom options_from_collection_for_select to return strftime as selection values instead of named properties of the objects of the collection
module ActionView::Helpers::FormOptionsHelper
  
  def date_options_from_collection_for_select(collection, value_method=nil, selected = nil)
    options = collection.map do |element|
      element = element.first # contains by default the timestamp created by group_by above
      [element.strftime("%B %Y"), "#{element.month}-#{element.year}"]
    end
    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end

end