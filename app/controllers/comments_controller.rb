class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ create edit update destroy ]
  before_action :set_comment, only: %i[ edit update destroy ]

  def edit
    authorize @comment
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: "Comment successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    authorize @comment

    if @comment.save
      redirect_to post_path(@post), notice: "Comment successfully added."
    else
      redirect_to post_path(@post), alert: "Error please try again."
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to post_path(@post), notice: "Comment successfully deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end
end
