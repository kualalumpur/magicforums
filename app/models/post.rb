class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
end
