votesChannelFunctions = () ->

  upVote = (data) ->
    $(".comment[data-id=#{data.comment_id}] .votes").html(data.value);

  downVote = (data) ->
    $(".comment[data-id=#{data.comment_id}] .votes").html(data.value);

  if $('.comments.index').length > 0
    App.votes_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },
    connected: () ->
      console.log("loaded terrence connected votes channel coffee")
    disconnected: () ->

    received: (data) ->
      switch data.type
        when "upvote" then upVote(data)
        when "downvote" then downVote(data)

$(document).on 'turbolinks:load', votesChannelFunctions
