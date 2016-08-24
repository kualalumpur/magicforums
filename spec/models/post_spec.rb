require 'rails_helper'

RSpec.describe Post, type: :model do
  context "assocation" do
    it { should have_many(:comments) }
    it { should belong_to(:topic) }
    it { should belong_to(:user) }
  end

  context "title validation" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(5) }
  end

  context "body validation" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(20) }
  end

  context "slug callback" do
    it "should set slug" do
      post = create(:post)

      expect(post.title).to eql(post.slug)
    end

    it "should update slug" do
      post = create(:post)

      post.update(title: "updated title")

      expect(post.slug).to eql("updated title")
    end
  end

end
