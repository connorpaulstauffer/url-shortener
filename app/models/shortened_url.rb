# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string
#  short_url    :string
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base

  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :submitter_id, presence: true

  belongs_to :submitter,
             class_name: :User,
             foreign_key: :submitter_id,
             primary_key: :id
             
  def self.random_code

    code = SecureRandom.urlsafe_base64

    while exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    create!(short_url: random_code,long_url: long_url,submitter_id: user.id)
  end

end
