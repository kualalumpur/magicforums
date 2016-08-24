FactoryGirl.define do
  factory :comment do
    body "Comment Body Comment Body Comment Body"
    post_id { create(:post, :sequenced_title, :sequenced_body).id }
    user_id { create(:user, :sequenced_username, :sequenced_email).id }

    trait :sequenced_body do
      body
    end
  end
end
