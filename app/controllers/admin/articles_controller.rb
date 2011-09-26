class Admin::ArticlesController < ApplicationController
  
  before_filter :authenticate_admin
  
  layout 'admin/layouts/main'
  
  # GET /articles/new
  # GET /articles/new.xml
  
  def index
    @articles = Article.order("created_at DESC")
  end
  
  def show
    @article = Article.find(params[:id])
  end
  
  def new
    @article = Article.new(params[:article])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end
  
  def preview
    @article = Article.new(params[:article])
    @article.created_at = Time.now
    if not @article.valid?
      render :action => 'new'
    end
  end
  
  # POST /articles
  # POST /articles.xml
  def create
    Article.transaction do
      @article = Article.new(params[:article])
      respond_to do |format|
        if @article.save
          @article.deliver_to_listhost unless @article.no_mail == "1"
          flash[:notice] = 'Article was successfully created.'
          format.html { redirect_to admin_articles_path }
          format.xml  { render :xml => @article, :status => :created, :location => @article }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to admin_article_path(@article) }
        format.xml  { head :ok }
        format.js { render :text => "Attributes updated." }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
      format.xml  { head :ok }
    end
  end
  
end
