class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  paginates_per 3
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
end
