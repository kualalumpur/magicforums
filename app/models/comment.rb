class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 20 }, presence: true
  paginates_per 4
  has_many :votes

  def total_votes(comment_id)
    Vote.where(comment_id: comment_id).sum(:value)
  end

end
