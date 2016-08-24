require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:all) do
    @user = create(:user)
  end

  describe "create session" do
    it "should create new session" do

      params = { user: {email: @user.email, password: @user.password} }

      post :create, params: params

      expect(session[:id]).to eql(@user.id)
      expect(flash[:success]).to eql("Welcome back #{@user.username}!")
      expect(subject).to redirect_to(root_path)
    end
  end

  describe "destroy session" do
    it "should destroy session" do

      post :create, params: { user: {email: @user.email, password: @user.password} }

      params = { id: @user.id }
      delete :destroy, params: params

      expect(flash[:success]).to eql("You've been logged out.")
      expect(session[id: @user.id]).to eql(nil)
    end
  end

end
