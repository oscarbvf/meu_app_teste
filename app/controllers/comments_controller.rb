class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_post, only: %i[ create edit update destroy ]
  before_action :set_comment, only: %i[ edit update destroy ]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.save
        flash.now[:notice] = "Comment added."
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added." }
      else
        flash.now[:alert] = "There was a problem creating the comment."
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@post, :new_comment),
            partial: "comments/form",
            locals: { post: @post, comment: @comment }
          ), status: :unprocessable_entity
        end
        format.html do
          render partial: "comments/form",
                locals: { post: @post, comment: @comment },
                status: :unprocessable_entity
        end
      end
    end
  end

  def edit
    @comment = @post.comments.find(params[:id])
  end

  def update
    @comment = @post.comments.find(params[:id])

    if @comment.update(comment_params)
      flash.now[:notice] = "Comment successfully updated."
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment updated successfully." }
      end
    else
      flash.now[:alert] = "There was a problem updating the comment."
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash.now[:notice] = "Comment deleted."

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "Comment deleted." }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
