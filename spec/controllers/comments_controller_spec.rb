require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before(:all) do
    @admin = User.create({email: "adminRSpec@adminRSpec.com", password: "adminRSpec", username: "adminRSpec", role: "admin"})
    @user = User.create({email: "testRSpec@testRSpec.com", password: "testRSpec", username: "testRSpec"})
    @unauthorized_user = User.create({email: "testRSpec2@testRSpec2.com", password: "testRSpec2", username: "testRSpec2"})
    @topic = Topic.create({title: "Topic Title 1", description: "Topic Description Topic Description 1", user_id: @admin.id})
    @post = Post.create({title: "Post Title 1", body: "Post Body Post Body 1", user_id: @user.id, topic_id: @topic.id})
    @comment = Comment.create({body: "Comment Body Comment Body 1", user_id: @user.id, post_id: @post.id})
  end

  describe "index comment" do
    it "should show comments index" do
      params = { topic_id: @topic.id, post_id: @post.id }
      get :index, params: params
      expect(assigns[:comments].count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create comment" do
    it "should create new comment" do

      params = { topic_id: @topic.id, post_id: @post.id, comment: {body: "This is RSpec Comment Body"} }

      post :create, params: params, session: {id: @user.id}, xhr: true

      comment = Comment.find_by(body: "This is RSpec Comment Body")

      expect(Comment.count).to eql(2)
      expect(comment.body).to eql("This is RSpec Comment Body")
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  end

  describe "edit comment" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should render edit" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, params: params, session: { id: @user.id }, xhr: true

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end

  end

  describe "update comment" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should update comment" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{body: "Edited Comment Body Comment Body 1"} }
      patch :update, params: params, session: { id: @user.id }, xhr: true

      @comment.reload

      expect(@comment.body).to eql("Edited Comment Body Comment Body 1")
      expect(flash[:success]).to eql("You've updated the comment.")
    end
  end


  describe "destroy comment" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should destroy comment" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params, session: { id: @user.id }, xhr: true

      expect(flash[:success]).to eql("You've deleted the comment.")
      expect(Comment.count).to eql(0)
    end
  end

end
