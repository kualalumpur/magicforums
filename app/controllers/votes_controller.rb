class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:upvote, :downvote]

  def upvote
    @comment = Comment.find_by(id: params[:comment_id])
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: +1)
      VoteBroadcastJob.perform_later("upvote", @vote.comment)
      flash.now[:success] = "You've upvoted the comment."
    else
      flash.now[:danger] = @vote.errors.full_messages
    end
  end

  def downvote
    @comment = Comment.find_by(id: params[:comment_id])
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: -1)
      VoteBroadcastJob.perform_later("downvote", @vote.comment)
      flash.now[:success] = "You've downvoted the comment."
    else
      flash.now[:danger] = @vote.errors.full_messages
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:value, :user_id, :comment_id)
  end

end
