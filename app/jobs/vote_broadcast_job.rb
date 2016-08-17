class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type, comment)
    ActionCable.server.broadcast 'votes_channel', type: type, comment_id: comment.id, value: comment.total_votes(comment.id)
  end

end
