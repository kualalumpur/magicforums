require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  before(:all) do
    @admin = create(:user, :admin)
    @topic = create(:topic)
    @user = create(:user)
    @unauthorized_user = create(:user, :sequenced_username, :sequenced_email)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
  end

  describe "index post" do
    it "should show posts index" do
      params = { topic_id: @topic.id }
      get :index, params: params
      expect(assigns[:posts].count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create post" do
    it "should create new post" do

      params = { topic_id: @topic.id, post: { title: "This is RSpec Post Title", body: "This is RSpec Post Body"} }

      post :create, params: params, session: {id: @user.id}, xhr: true

      post = Post.find_by(title: "This is RSpec Post Title")

      expect(Post.count).to eql(2)
      expect(post.title).to eql("This is RSpec Post Title")
      expect(post.body).to eql("This is RSpec Post Body")
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

  describe "edit post" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should render edit" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end

  end

  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should update post" do

      params = { topic_id: @topic.id, id: @post.id, post:{title: "Edited Post Title 1", body: "Edited Post Body Post Body 1"} }
      patch :update, params: params, session: { id: @user.id }

      @post.reload

      expect(@post.title).to eql("Edited Post Title 1")
      expect(@post.body).to eql("Edited Post Body Post Body 1")
      expect(flash[:success]).to eql("You've updated the post.")
      expect(subject).to redirect_to(topic_posts_path(@topic))
    end
  end


  describe "destroy post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should destroy post" do

      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(topic_posts_path(@topic))
      expect(flash[:success]).to eql("You've deleted the post.")
      expect(Post.count).to eql(0)
    end
  end

end
