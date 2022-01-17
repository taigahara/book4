class PostCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.book_id = book.id
    if comment.save
      flash[:success] = "Comment was successfully created."
      redirect_to book_path(book)
    else
      redirect_to request.referer
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:book_id])
    if @post_comment.user != current_user
      redirect_to request.referer
    else
      @post_comment.destroy
      redirect_to request.referer
    end
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
