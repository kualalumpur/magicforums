class PostsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :destroy]

  def index
    @topic = Topic.includes(:posts).find(params[:topic_id])
    @posts = @topic.posts.order("created_at DESC").page params[:page]
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    # @post = Post.new(post_params.merge(topic_id: params[:topic_id]))
    @post = current_user.posts.build(post_params.merge(topic_id: @topic.id))
    @new_post = Post.new

    if @post.save
      flash.now[:success] = "You've created a new post."
    else
      flash.now[:danger] = @post.errors.full_messages
    end
  end

  def edit
    @post = Post.find(params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update
  #  @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find(params[:id])
  #  @post = Post.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.update(post_params)
      flash[:success] = "You've updated the post."
      redirect_to topic_posts_path(@topic)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.destroy
      flash[:success] = "You've deleted the post."
      redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :body)
  end
end
