votesChannelFunctions = () ->

  pluralize = (num, variant1, variant2, variant3)->
    plural =
      if num % 10 == 1 && num % 100 != 11
        0
      else if num % 10 >= 2 && num % 10 <= 4 && (num % 100 < 10 || num % 100 >= 20)
        1
      else
        2

    switch plural
      when 0 then num + " " + variant1
      when 1 then num + " " + variant2
      when 2 then num + " " + variant3

  upVote = (data) ->
    $(".comment[data-id=#{data.comment_id}] .votes").html(pluralize(data.value, 'vote', 'votes', 'vote'));

  downVote = (data) ->
    $(".comment[data-id=#{data.comment_id}] .votes").html(pluralize(data.value, 'vote', 'votes', 'vote'));

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
