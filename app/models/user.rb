class User < ApplicationRecord
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  mount_uploader :image, ImageUploader
  validates :email, length: { minimum: 10 }, presence: true, uniqueness: true
  validates :username, length: { minimum: 5 }, presence: true, uniqueness: true
  enum role: [:user, :moderator, :admin]
  has_many :votes
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  before_save :check_slug

  def check_slug
    self.slug = username if self.slug != username
  end
end
