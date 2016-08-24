require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user)
    @topic = create(:topic)
  end

  describe "index topic" do
    it "should show topics index" do
      get :index
      expect(assigns[:topics].count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create topic" do
    it "should create new topic" do

      params = { topic: { title: "This is RSpec Topic Title", description: "This is RSpec Topic Description" } }

      post :create, params: params, session: {id: @admin.id}, xhr: true

      topic = Topic.find_by(title: "This is RSpec Topic Title")

      expect(Topic.count).to eql(2)
      expect(topic.title).to eql("This is RSpec Topic Title")
      expect(topic.description).to eql("This is RSpec Topic Description")
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end

  describe "edit topic" do

    it "should redirect if not logged in" do

      params = { id: @topic.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should render edit" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @admin.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end

  end

  describe "update topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id }
      patch :update, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should update topic" do

      params = { id: @topic.id, topic:{title: "Edited Topic Title 1", description: "Edited Topic Description Topic Description 1"} }
      patch :update, params: params, session: { id: @admin.id }

      @topic.reload

      expect(@topic.title).to eql("Edited Topic Title 1")
      expect(@topic.description).to eql("Edited Topic Description Topic Description 1")
      expect(flash[:success]).to eql("You've updated the topic.")
      expect(subject).to redirect_to(topics_path)
    end
  end


  describe "destroy topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first.")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized!")
    end

    it "should destroy topic" do

      params = { id: @topic.id }
      delete :destroy, params: params, session: { id: @admin.id }

      expect(subject).to redirect_to(topics_path)
      expect(flash[:success]).to eql("You've deleted the topic.")
      expect(Topic.count).to eql(0)
    end
  end

end
