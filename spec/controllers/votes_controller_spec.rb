require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  before(:all) do
    @admin = User.create({email: "adminRSpec@adminRSpec.com", password: "adminRSpec", username: "adminRSpec", role: "admin"})
    @user = User.create({email: "testRSpec@testRSpec.com", password: "testRSpec", username: "testRSpec"})
    @topic = Topic.create({title: "Topic Title 1", description: "Topic Description Topic Description 1", user_id: @admin.id})
    @post = Post.create({title: "Post Title 1", body: "Post Body Post Body 1", user_id: @user.id, topic_id: @topic.id})
    @comment = Comment.create({body: "Comment Body Comment Body 1", user_id: @user.id, post_id: @post.id})
    @vote = Vote.create({value: 0, user_id: @admin.id, comment_id: @comment.id})
  end

  describe "upvote comment" do

    it "should redirect if not logged in" do

      params = { id: @comment.id }
      post :upvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should upvote comment" do

      params = { comment_id: @comment.id }
      post :upvote, params: params, session: { id: @user.id }, xhr: true

      vote = Vote.find_by(comment_id: @comment.id)

      expect(flash[:success]).to eql("You've upvoted the comment.")
      expect(Vote.count).to eql(2)
      expect(assigns[:vote].value).to eql(1)
    end

  end

  describe "upvote comment" do

    it "should redirect if not logged in" do

      params = { id: @comment.id }
      post :upvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should downvote comment" do

      params = { comment_id: @comment.id }
      post :downvote, params: params, session: { id: @user.id }, xhr: true

      vote = Vote.find_by(comment_id: @comment.id)
      
      expect(flash[:success]).to eql("You've downvoted the comment.")
      expect(Vote.count).to eql(2)
      expect(assigns[:vote].value).to eql(-1)
    end

  end


end
