class PostsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_post, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
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

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: "Post was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize @post
    if @post.update(post_params)
      respond_to do |format|
        format.turbo_stream { render :update } # update.turbo_stream.erb
        format.html { redirect_to post_path(@post), notice: "Post updated" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit } # mostra o form com erros
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.turbo_stream { render :destroy } # remove o post do frame
      format.html { redirect_to posts_path, notice: "Post was successfully deleted" }
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
