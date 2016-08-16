postsChannelFunctions = () ->
  checkMe = (comment_id, username) ->
    user_meta = "meta[me=#{username}]"
    unless $('meta[magic=oldguard]').length > 0 || $(user_meta).length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  createComment = (data) ->
    if $('.comments.index').data().id == data.post.id
      $('#comments').append(data.partial)
      checkMe(data.comment.id, data.username)
      if document.hidden
        notification = new Notification data.post.title, body: data.comment.body, icon: data.post.image.thumb.url

        notification.onclick = () ->
          window.focus()
          this.close()      

  updateComment = (data) ->
    if $('.comments.index').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").after(data.partial).remove();
      checkMe(data.comment.id, data.username)

  destroyComment = (data) ->
    if $('.comments.index').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").remove();

  if $('.comments.index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("loaded terrence connected posts channel coffee")

    disconnected: () ->

    received: (data) ->
      switch data.type
        when "create" then createComment(data)
        when "update" then updateComment(data)
        when "destroy" then destroyComment(data)

$(document).on 'turbolinks:load', postsChannelFunctions
