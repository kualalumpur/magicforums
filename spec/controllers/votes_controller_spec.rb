require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  before(:all) do
    @user = create(:user, :sequenced_username, :sequenced_email)
    @comment = create(:comment)
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


      expect(flash[:success]).to eql("You've upvoted the comment.")
      expect(Vote.count).to eql(1)
      expect(assigns[:vote].value).to eql(1)
    end

  end

  describe "downvote comment" do

    it "should redirect if not logged in" do

      params = { id: @comment.id }
      post :upvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should downvote comment" do

      params = { comment_id: @comment.id }
      post :downvote, params: params, session: { id: @user.id }, xhr: true

      expect(flash[:success]).to eql("You've downvoted the comment.")
      expect(Vote.count).to eql(1)
      expect(assigns[:vote].value).to eql(-1)
    end

  end


end
