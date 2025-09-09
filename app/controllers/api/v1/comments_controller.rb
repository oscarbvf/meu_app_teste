module Api
  module V1
    class CommentsController < BaseController
      before_action :authenticate_request # Comment belongs to an User
      before_action :set_post # Comment belongs to a Post
      before_action :set_comment, only: [ :show, :update, :destroy ]

      def index
        @comments = policy_scope(@post.comments)
        render json: { status: "success", data: @comments.as_json(include: :user) }
      end

      def show
        authorize @comment
        render json: { status: "success", data: @comment.as_json(include: :user) }
      end

      def create
        @comment = @post.comments.build(comment_params.merge(user: @current_user))
        authorize @comment

        if @comment.save
          render json: { status: "success", data: @comment.as_json(include: :user) }, status: :created
        else
          render json: { status: "error", errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @comment
        if @comment.update(comment_params)
          render json: { status: "success", data: @comment }
        else
          render json: { status: "error", errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @comment
        @comment.destroy
        render json: { status: "success", data: { message: "Comment successfully deleted." } }
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
  end
end
