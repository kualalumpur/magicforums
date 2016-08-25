require "rails_helper"

RSpec.feature "User adds new comment and deletes it", type: :feature, js: true do

  before(:all) do
    @user = create(:user)
    @topic = create(:topic)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
    @comment = create(:comment, post_id: @post.id, user_id: @user.id)
  end

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit("http://localhost:3000")
    visit root_path
    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
    end

    click_button('Sign In')
    click_link(@topic.title)
    click_link(@post.title)
    fill_in 'Body', with: 'This is the comment body of feature testing'
    click_button('Create Comment')

    expect(page).to have_current_path(topic_post_comments_path(@topic.id, @post.id))
    expect(find('.flash-messages .message').text).to eql("You've created a new comment.")
    
    comment = Comment.find_by(body: "This is the comment body of feature testing")

    expect(Comment.count).to eql(2)
    expect(comment).to be_present



    within(:css, '.comment[data-id=2]') do
      click_button('fa-edit')
      fill_in 'Body', with: 'Edited: this is the comment body of feature testing'
      click_button('Update Comment')
    end

    expect(find('.flash-messages .message').text).to eql("You've updated the comment.")

    within(:css, '.comment[data-id=2]') do
      click_button('fa-arrow-up')
      expect(find('.votes').text).to eql("1 vote")
    end

    expect(find('.flash-messages .message').text).to eql("You've upvoted the comment.")

    within(:css, '.comment[data-id=1]') do
      click_button('fa-arrow-down')
      expect(find('.votes').text).to eql("-1 vote")
    end

    expect(find('.flash-messages .message').text).to eql("You've downvoted the comment.")

    within(:css, '.comment[data-id=2]') do
      click_button('fa-trash')
    end

    expect(find('.flash-messages .message').text).to eql("You've deleted the comment.")
    expect(Comment.count).to eql(1)

  end

end
