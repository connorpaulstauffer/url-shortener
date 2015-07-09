# == Schema Information
#
# Table name: votes
#
#  id               :integer          not null, primary key
#  shortened_url_id :integer
#  voter_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  upvote           :boolean          default("t")
#

class Vote < ActiveRecord::Base

  validates :shortened_url_id, presence: true
  validates :voter_id, presence: true
  validate :one_vote_per_user
  validate :not_voting_for_own_url

  belongs_to :voter,
             class_name: :User,
             foreign_key: :voter_id,
             primary_key: :id

  belongs_to :shortened_url,
             class_name: :ShortenedUrl,
             foreign_key: :shortened_url_id,
             primary_key: :id

  private

  def one_vote_per_user
    if Vote.exists?(shortened_url_id: shortened_url_id, voter_id: voter_id)
      errors[:vote] << "only one vote per user on each url"
    end
  end

  def not_voting_for_own_url
    url = ShortenedUrl.find_by_id(shortened_url_id)
    if url.submitter_id == voter_id
      errors[:vote] << "user can't vote for his own url"
    end
  end

end
