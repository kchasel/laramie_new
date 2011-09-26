class Admin::CommentsController < ApplicationController
  
  before_filter :authenticate_admin
  
  def destroy
    @comment = Comment.find(params[:id])
    article = @comment.article
    if @comment.destroy
      flash[:notice] = "Comment deleted."
      redirect_to admin_article_path(article)
    else
      flash[:notice] = "There was an error deleting the comment."
    end
  end
  
  def delete_all
    article = Article.find(params[:id])
    article.comments.delete_all
    redirect_to admin_article_path(article)
  end
  
end
