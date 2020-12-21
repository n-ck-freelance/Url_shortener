require 'open-uri'

class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, presence: true
  validate :validate_full_url

  after_save  :add_update_title_job

  def short_code
    ApplicationController.helpers.get_short_code_by id
  end

  def public_attributes
    {
      'full_url' => full_url,
      'title' => title,
      'short_code' => short_code,
    }
  end

  def update_title!
    open(full_url) do |f|
      str = f.read
      self.title = str.scan(/<title>(.*?)<\/title>/)[0][0]
    end
    save
  end

  def self.find_by_short_code(short_code)
    ShortUrl.find_by_id(ApplicationController.helpers.get_number_by short_code)
  end

  private

  def validate_full_url
    uri = URI.parse(full_url) if full_url.present?
    errors.add(:full_url, "is not a valid url") unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:full_url, "is not a valid url")
  end

  def add_update_title_job
    UpdateTitleJob.perform_later id if saved_changes[:full_url].present?
  end

end
