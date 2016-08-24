FactoryGirl.define do
  sequence :title do |n|
    "title-#{n} title title"
  end

  sequence :description do |n|
    "description-#{n} description description"
  end

  sequence :body do |n|
    "super-heavy-body-#{n} super-heavy-body"
  end
end
