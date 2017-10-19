class ShortenedUrl < ApplicationRecord

  validates :long_url, :user_id, presence: true
  validates :short_url, presence: true, uniqueness: true

  def self.random_code
    code = SecureRandom::urlsafe_base64
    if ShortenedUrl.exists?(:short_url => code)
      code = ShortenedUrl.random_code
    end
    code
  end

  def self.create!(user, longurl)
    short = ShortenedUrl.random_code
    result = ShortenedUrl.new(user_id:user.id, short_url:short, long_url:longurl)
  end

  # has_many :tag_topics,
  # class_name: :TagTopic,
  # primary_key: :id,
  # foreign_key: :

  belongs_to :submitter,
  class_name: :User,
  primary_key: :id,
  foreign_key: :user_id

  has_many :visits,
  class_name: :Visit,
  primary_key: :id,
  foreign_key: :shortened_url_id

  has_many :visitors,
    ->{ distinct },
    through: :visits,
    source: :user

  def num_clicks
    self.visits.length
  end

  def num_uniques
    # Visit.select(:user_id).distinct.where(shortened_url_id: self.id).count
    visitors.count
  end

  def num_recent_uniques
    Visit.select(:user_id).distinct.where(
      shortened_url_id: self.id,
      created_at: (Time.now - 10.minutes)..(Time.now)
    ).count
  end



end
