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
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added." }
      else
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
    # if @comment.update(comment_params)
    #  respond_to do |format|
    #    format.turbo_stream do
    #      render turbo_stream: turbo_stream.replace(
    #        dom_id(@comment),
    #        partial: "comments/comment",
    #        locals: { comment: @comment }
    #      )
    #    end
    #    format.html { redirect_to @post, notice: "Comment updated successfully." }
    #  end
    # else
    #  respond_to do |format|
    #    format.turbo_stream do
    #      render turbo_stream: turbo_stream.replace(
    #        dom_id(@comment),
    #        partial: "comments/form",
    #        locals: { post: @post, comment: @comment }
    #      )
    #    end
    #    format.html { render :edit, status: :unprocessable_entity }
    #  end
    # end
    @comment = @post.comments.find(params[:id])

    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment updated successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @comment.destroy
    # respond_to do |format|
    #  format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@comment)) }
    #  format.html { redirect_to @post, notice: "Comment deleted." }
    # end
    @comment = @post.comments.find(params[:id])
    @comment.destroy

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
