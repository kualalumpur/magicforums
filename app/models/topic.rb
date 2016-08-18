class Topic < ApplicationRecord
  has_many :posts
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
end
