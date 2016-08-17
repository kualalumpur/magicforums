class User < ApplicationRecord
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  mount_uploader :image, ImageUploader
  validates :email, length: { minimum: 10 }, presence: true
  validates :username, length: { minimum: 5 }, presence: true
  enum role: [:user, :moderator, :admin]
  has_many :votes
end
