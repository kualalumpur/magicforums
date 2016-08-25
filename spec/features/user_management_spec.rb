require "rails_helper"

RSpec.feature "User Management", type: :feature do
  before(:all) do
    @user = create(:user)
  end

  scenario "User registers" do
    visit root_path
    click_link('Register')

    within(:css, "#register") do
      fill_in 'Email', with: 'ironman@email.com'
      fill_in 'Username', with: 'ironman'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign Up')

    user = User.find_by(email: "ironman@email.com")

    expect(User.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("ironman@email.com")
    expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("You've created a new user.")
    expect(page).to have_current_path(topics_path)
  end

  scenario "User updates details" do
    visit root_path
    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign In')

    click_link(@user.username)
    within(:css, "#user-update-form") do
      fill_in 'Email', with: 'editeduser@email.com'
      fill_in 'Username', with: 'editedbob555'
      fill_in 'Password', with: 'editedpassword'
    end
    click_button('Update Account')
    expect(find('.flash-messages .message').text).to eql("You've updated the user.")
    expect(page).to have_current_path(topics_path)

    user = User.find_by(email: "editeduser@email.com")

    expect(user).to be_present
    expect(user.email).to eql("editeduser@email.com")
    expect(user.username).to eql("editedbob555")

    click_link('Logout')
    click_button('close-button')

    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'editeduser@email.com'
      fill_in 'Password', with: 'editedpassword'
    end

    click_button('Sign In')

    expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}!")
    expect(page).to have_current_path(topics_path)
  end

end
