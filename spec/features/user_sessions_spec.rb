require "rails_helper"

RSpec.feature "User Sessions", type: :feature do
  before(:all) do
    @user = create(:user)
  end

  scenario "User logs in" do
    visit root_path
    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign In')

    expect(find('.flash-messages .message').text).to eql("Welcome back #{@user.username}!")
    expect(page).to have_current_path(topics_path)
  end

  scenario "User logs out" do
    visit root_path
    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign In')

    click_link('Logout')

    expect(find('.flash-messages .message').text).to eql("You've been logged out.")
    expect(page).to have_current_path(topics_path)

  end

end
