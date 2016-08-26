# Important Note to Terrence
# Before run this test need to change the comment data-id to the latest id
# This file is using the development server

require "rails_helper"


RSpec.feature "User adds new comment and deletes it", type: :feature, js: true do

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit("http://localhost:3000")

    click_link('Login')

    within(:css, "#login") do
      fill_in 'Email', with: 'qwerty@qwerty.com'
      fill_in 'Password', with: 'qwerty'
    end

    click_button('Sign In')
    click_link("Test Ajax Topic")
    click_link("Test Ajax Post")
    fill_in 'Body', with: 'This is the comment body of feature testing'
    click_button('Create Comment')

    expect(page).to have_current_path(topic_post_comments_path("test-ajax-topic", "test-ajax-post"))

    sleep(1)

    all('.comment').last.find('.fa-edit').click

    sleep(1)

    all('.comment').last.fill_in 'Body', with: 'Edited: this is the comment body of feature testing'

    sleep(1)

    all('.comment').last.click_button('Update Comment')

    sleep(1)

    expect(find('.flash-messages .message').text).to eql("You've updated the comment.")

    sleep(1)

    all('.comment').last.find('.fa-arrow-up').click

    sleep(3)

    expect(find('.flash-messages .message').text).to eql("You've upvoted the comment.")

    sleep(1)

    expect(all('.comment').last.find('.votes').text).to eql("1 vote")

    sleep(1)

    all('.comment').last.find('.fa-arrow-down').click

    sleep(3)

    expect(find('.flash-messages .message').text).to eql("You've downvoted the comment.")

    sleep(1)

    expect(all('.comment').last.find('.votes').text).to eql("-1 vote")

    sleep(1)

    all('.comment').last.find('.fa-trash').click

    page.driver.browser.switch_to.alert.accept

    expect(find('.flash-messages .message').text).to eql("You've deleted the comment.")

  end

end
