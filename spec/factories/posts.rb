FactoryGirl.define do
  factory :post do
    title "Post Title Post"
    body "Post Body Post Body Post Body Post Body"

    topic_id { create(:topic, :sequenced_title, :sequenced_description).id }

    user_id { create(:user, :sequenced_username, :sequenced_email).id }

    trait :sequenced_title do
      title
    end

    trait :sequenced_body do
      body
    end
  end
end
