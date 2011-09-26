# Comments have been removed in this version of the NLRA site

=begin
class CommentsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create, :update, :destroy, :edit]
  
  layout 'main'
  
  # GET new_article_comment(:article_id)
  def new
    @article = Article.find(params[:article_id])
    if current_user.no_comments
      flash[:notice] = "You are prohibited from commenting."
      redirect_to article_url(@article)
      return
    end
    @comment = @article.comments.new
  end
  
  # POST article_comments/account_comments
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(params[:comment])
    @comment.account_id = current_user.id
    if current_user.no_comments
      flash[:notice] = "You are prohibited from commenting."
      respond_to do |format|
        format.js { render(:update) { |page| page.redirect_to(article_url(@article)) } }
        format.html { redirect_to article_url(@article) }
      end
      return
    end
    Comment.transaction do
    if @comment.save
      respond_to do |format|
        format.js
        format.html
      end
    else
      render new_article_comment
    end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    article = @comment.article
    if @comment.account_id == current_user.id
      @comment.destroy
      unless request.xhr?
        redirect_to article_path(article)
      end
      render(:update) do |page|
        page.visual_effect :drop_out, "comment_#{@comment.id}"
        page << "if($('comment_#{@comment.id}').previous(0)==undefined && $('comment_#{@comment.id}').next(0)!=undefined) { $('comment_#{@comment.id}').next(0).remove() } 
                  else if($('comment_#{@comment.id}').previous(0)!=undefined) { $('comment_#{@comment.id}').previous(0).remove() };"
        page.delay(1) do
          page.remove "comment_#{@comment.id}"
          page.hide "allcomments" if article.comments.blank?
          page << "stickToBottom();"
        end
      end
    end
  end
end
=end