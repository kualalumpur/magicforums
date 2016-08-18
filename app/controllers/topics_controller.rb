class TopicsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :destroy]

  def index
    @topics = Topic.all
    @topic = Topic.new
  end

  # def show
  #   @topic = Topic.find_by(id: params[:id])
  # end

  def create
    @topic = current_user.topics.build(topic_params)
    authorize @topic
    @new_topic = Topic.new

    if @topic.save
      flash.now[:success] = "You've created a new topic."
    else
      flash.now[:danger] = @topic.errors.full_messages
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize @topic
  end

  def update
    @topic = Topic.find(params[:id])
    authorize @topic

    if @topic.update(topic_params)
      flash[:success] = "You've updated the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to edit_topic_path(@topic)
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    authorize @topic

    if @topic.destroy
      flash[:success] = "You've deleted the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to topic_path(@topic)
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :description)
  end
end
