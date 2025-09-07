module Api
  module V1
    class Api::V1::CommentsController < ActionController::API
      def index
        post = Post.find(params[:post_id])
        render json: post.comments, status: :ok
      end

      def create
        post = Post.find(params[:post_id])
        comment = post.comments.build(comment_params.merge(user: current_user || User.first))
        # TODO: replace for JWT/Token authentication
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
