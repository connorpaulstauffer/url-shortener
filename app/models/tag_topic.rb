# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class TagTopic < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  has_many :taggings,
           class_name: :Tagging,
           foreign_key: :tag_id,
           primary_key: :id

  has_many :shortened_urls, through: :taggings, source: :shortened_url

  def most_popular_links(n)
    shortened_urls
    .joins('LEFT JOIN visits v on v.shortened_url_id = shortened_urls.id')
    .group('shortened_urls.id')
    .order('COUNT(v.id) DESC').limit(n)
  end

end
