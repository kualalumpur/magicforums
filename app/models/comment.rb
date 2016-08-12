class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 20 }, presence: true
  paginates_per 3
end
