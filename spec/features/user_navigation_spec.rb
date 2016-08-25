require "rails_helper"

RSpec.feature "User Navigation", type: :feature do
  before(:all) do
    @user = create(:user)
    @topic = create(:topic)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
    @comment = create(:comment, post_id: @post.id, user_id: @user.id)
  end

  scenario "User visits about, topic, post and comment pages" do
    visit root_path
    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign In')

    expect(find('.flash-messages .message').text).to eql("Welcome back #{@user.username}!")
    expect(page).to have_current_path(topics_path)

    click_link('About')

    expect(page).to have_current_path(about_path)

    click_link('Topics')

    expect(page).to have_current_path(topics_path)

    click_link(@topic.title)

    expect(page).to have_current_path(topic_posts_path(@topic.slug))

    click_link(@post.title)

    expect(page).to have_current_path(topic_post_comments_path(@topic.slug, @post.slug))

    click_link('Logout')
    click_button('close-button')

  end


  scenario "User visits reset password page" do
    visit root_path
    click_link('Login')
    click_link('Reset Password')

    expect(page).to have_current_path(new_password_reset_path)

    within(:css, "#user-reset-password-form") do
      fill_in 'Email', with: 'user@email.com'
    end

    click_button('Reset my password!')

    expect(find('.flash-messages .message').text).to eql("We've sent you instructions on how to reset your password.")
    expect(page).to have_current_path(topics_path)
  end
end
