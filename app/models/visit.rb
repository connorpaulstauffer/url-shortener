# == Schema Information
#
# Table name: visits
#
#  id               :integer          not null, primary key
#  visitor_id       :integer
#  shortened_url_id :string
#  created_at       :datetime
#  updated_at       :datetime
#

class Visit < ActiveRecord::Base

  validates :visitor_id, presence: true
  validates :shortened_url_id, presence: true

  def self.record_visit!(user, shortened_url)
    create!(visitor_id: user.id, shortened_url_id: shortened_url.id)
  end

end
