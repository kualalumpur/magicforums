require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  before(:all) do
    @user = create(:user)
  end

  describe "new reset password" do
    it "should render new" do

      get :new
      expect(subject).to render_template(:new)
    end
  end

  describe "create reset password" do
    it "should create reset password" do

      params = { reset: {email: @user.email} }

      post :create, params: params

      @user.reload
      expect(ActionMailer::Base.deliveries.count).to eql(1)
      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(flash[:success]).to eql("We've sent you instructions on how to reset your password")
      expect(subject).to redirect_to(new_password_reset_path)
    end

    it "should show error if user does not exist" do

      params = { reset: {email: "doesnot@exist.com"} }

      post :create, params: params

      @user.reload
      expect(@user.password_reset_token).to be_nil
      expect(@user.password_reset_at).to be_nil
      expect(flash[:danger]).to eql("User does not exist")
    end
  end


  describe "edit reset password" do

    it "should edit reset password" do

      params = { id: "resettoken" }
      get :edit, params: params

      expect(subject).to render_template(:edit)
      expect(assigns[:token]).to eql("resettoken")
    end

  end

  describe "update reset password" do

    it "should update reset password" do

      params = { reset: {email: @user.email} }
      post :create, params: params

      @user.reload

      params = { id: @user.password_reset_token, user: { password: "newpassword" } }
      patch :update, params: params

      @user.reload

      user = @user.authenticate("newpassword")
      expect(user).to be_present
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_at).to be_nil
      expect(flash[:success]).to eql("Password updated, you may log in now")
      expect(subject).to redirect_to(root_path)
    end

  end

end
