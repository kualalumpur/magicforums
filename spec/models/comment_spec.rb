require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "assocation" do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
    it { should have_many(:votes) }
  end

  context "body validation" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(20) }
  end

  context "total votes" do
    it "should return vote sum" do

      user = create(:user, :sequenced_username, :sequenced_email)
      comment = create(:comment)
      user.votes.create(comment_id: comment.id, value: +1)
      expect(comment.total_votes(comment.id)).to eql(1)
      user.votes.create(comment_id: comment.id, value: -1)
      expect(comment.total_votes(comment.id)).to eql(0)
    end

  end
end
