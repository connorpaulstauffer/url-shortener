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

  has_many :visits,
           class_name: :Visit,
           foreign_key: :shortened_url_id,
           primary_key: :id

  has_many :visitors,
           Proc.new { distinct },
           through: :visits,
           source: :visitor


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

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visits.where(["created_at > ?", 10.minutes.ago]).map(&:id).uniq.count
  end

end
