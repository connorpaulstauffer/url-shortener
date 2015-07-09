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
  validates :long_url, presence: true, length: { maximum: 1024 }
  validates :submitter_id, presence: true
  validate :cannot_submit_more_than_five

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

  has_many :taggings,
           class_name: :Tagging,
           foreign_key: :shortened_url_id,
           primary_key: :id

  has_many :tag_topics, through: :taggings, source: :tag_topic


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

  def self.prune
    delete_all(["created_at < ?", 20.minutes.ago])
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

  private
  def cannot_submit_more_than_five
    user = User.find_by_id(submitter_id)
    user_urls = ShortenedUrl.where(["created_at > ? AND submitter_id = ?",
                                    1.minute.ago, self.submitter_id])
    if user_urls.length >= 5 && !user.premium
      errors[:shortened_url] << "can't submit more than 5 urls in 1 minute"
    end
  end

end
