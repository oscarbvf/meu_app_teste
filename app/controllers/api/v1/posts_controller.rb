module Api
  module V1
    class PostsController < BaseController
      skip_before_action :authenticate_request, only: [ :index, :show ]

      def index
        posts = Post.all
        render_success(posts)
      end

      def show
        post = Post.find(params[:id])
        render_success(post)
      end

      def create
        post = Post.new(post_params)
        if post.save
          render_success(post, :created)
        else
          render_error(post.errors.full_messages)
        end
      end

      def update
        post = Post.find(params[:id])
        if post.update(post_params)
          render_success(post)
        else
          render_error(post.errors.full_messages)
        end
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        render_success({ message: "Post successfully deleted." })
      end

      private

      def post_params
        params.require(:post).permit(:titulo, :conteudo)
      end
    end
  end
end
