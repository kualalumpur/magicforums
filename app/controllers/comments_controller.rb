class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :destroy]

  def index
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order("created_at DESC").page params[:page]
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    # @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.perform_later("create", @comment)
      flash.now[:success] = "You've created a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.update(comment_params)
      flash.now[:success] = "You've updated the comment."
      CommentBroadcastJob.set(wait: 0.1.seconds).perform_later("update", @comment)
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @topic = @comment.post.topic
    @post = @comment.post
    authorize @comment

    if @comment.destroy
      flash.now[:success] = "You've deleted the comment."
      CommentBroadcastJob.perform_now("destroy", @comment)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:image, :body)
  end
end
