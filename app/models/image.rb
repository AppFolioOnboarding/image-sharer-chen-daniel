class Image < ApplicationRecord
  validates :url, presence: true
  validate :image_url?
  acts_as_taggable
  scope :by_create_date, lambda {
    order(created_at: :desc)
  }

  def image_url?
    parsed_url = URI.parse(url)
    errors.add(:url, 'Invalid URL') unless parsed_url.is_a?(URI::HTTP) || parsed_url.is_a?(URI::HTTPS)

    suffix = %w[gif jpg jpeg png]

    errors.add(:url, 'Not a link to an image') if suffix.none? { |substr| url.include?(substr) }
  end
end
