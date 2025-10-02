class PostsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_post, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  def actions
    @post = Post.find(params[:id])
    render partial: "posts/post_actions", locals: { post: @post }
  end

  # GET /posts/1 or /posts/1.json
  def show
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "posts/post", formats: [ :html ], locals: { post: @post } }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    authorize @post
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    authorize @post
    respond_to do |format|
      format.html
      format.turbo_stream { render :edit }
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    authorize @post
    if @post.save
      flash.now[:notice] = "Post was successfully created."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("new_post", ""), 
            turbo_stream.prepend("notifications", partial: "shared/flash")
          ]
        end
        format.html { redirect_to posts_path, notice: "Post created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_post", partial: "posts/form", locals: { post: @post }) }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize @post
    if @post.update(post_params)
      flash.now[:notice] = "Post was successfully updated."
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Post successfully updated." }
        format.turbo_stream
    end
    else
      respond_to do |format|
        flash.now[:alert] = "There was a problem updating the post."
        format.turbo_stream { render :edit } # show errors
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    authorize @post
    @post.destroy
    flash.now[:notice] = "Post was successfully deleted."
    respond_to do |format|
      format.turbo_stream { render :destroy } # remove post from the frame
      format.html { redirect_to posts_path, notice: "Post was successfully deleted." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:titulo, :conteudo)
    end
end
