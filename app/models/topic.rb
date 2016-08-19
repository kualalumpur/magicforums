class Topic < ApplicationRecord
  has_many :posts
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  before_save :check_slug

  def check_slug
    self.slug = title if self.slug != title
  end
end
